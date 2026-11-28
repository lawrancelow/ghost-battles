# [opening] 上線前檢查：列出 story_v2.json 仍帶 rv（待審）嘅插圖；確認重跑 build.py 唔會將已拿掉嘅 rv 加返／抹走未審嘅 rv
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> rvclear res://tools/tests/rv_clear_test.gd all 300
#   all    ：只列清單（而家唔使清零），build.py 檢查要過
#   strict ：上線前用——清單一定要係 0
extends RefCounted
var ok := 0
var bad := 0
func _p(m): print("[rv] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func all(t) -> void: _run(false)
func strict(t) -> void: _run(true)
func _run(strict_: bool) -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string("res://data/story_v2.json"))
	var list: Array = []
	for sid in d.scenes:
		var cg = d.scenes[sid].get("cg")
		if not (cg is Dictionary): continue
		for li in cg:
			if cg[li] is Dictionary and str(cg[li].get("rv", "")) != "": list.append("%s:%s %s%s" % [sid, li, cg[li].get("k", ""), ("／女 " + str(cg[li].kf)) if cg[li].has("kf") else ""])
	if FileAccess.file_exists("res://data/cg_review.json"):
		var rj = JSON.parse_string(FileAccess.get_file_as_string("res://data/cg_review.json"))
		for k in rj.get("pending", []): list.append("素材 %s" % k)
	list.sort()
	_p("待審插圖 %d 張：" % list.size())
	for x in list: _p("  待審 " + x)
	_chk("待審清單可列出", true, list.size())
	if strict_: _chk("上線前：待審清單已清零", list.is_empty(), list.size())
	var out: Array = []
	var rc = OS.execute("python3", [ProjectSettings.globalize_path("res://tools/devkit/rv_build_check.py"), ProjectSettings.globalize_path("res://").trim_suffix("/")], out, true)
	var txt = "\n".join(out)
	for ln in txt.split("\n"): if ln.begins_with("BUILD") or ln.begins_with("  DIFF"): _p(ln)
	_chk("檢查腳本跑得起", rc == 0 and txt.contains("RV_COUNT "), rc)
	if txt.contains("BUILD skip"): _p("（搵唔到 build.py，略過重跑檢查）")
	else:
		_chk("build.py 冇 --force 唔寫檔", txt.contains("BUILD_NOFORCE ok"))
		_chk("build.py --force 重跑：已拿掉嘅 rv 冇加返、未審嘅 rv 冇被抹、插圖鍵冇變、stall_hook 冇塞返章節開場", txt.contains("BUILD_FORCE back=0 lost=0 keychg=0 stall_in_intro=0"))
	_p("RESULT ok=%d bad=%d" % [ok, bad])
