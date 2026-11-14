# 夜班巡陰（原生）：用回呼畫嘢嘅節點
class_name PtDraw
extends Node2D
var fn: Callable
var tag := ""
static var prof_us := 0
static var prof_n := 0
static var prof_tag := {}
func _draw() -> void:
	if not fn.is_valid(): return
	var t0 = Time.get_ticks_usec()
	fn.call(self)
	var d = Time.get_ticks_usec() - t0
	prof_us += d; prof_n += 1
	if tag != "": prof_tag[tag] = prof_tag.get(tag, 0) + d
