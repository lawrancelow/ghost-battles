# 行動目標登記（最小版；ctl 線建立正式版，整合時以 ctl 版為準）
#   AT.providers：靜態 Array of Callable；每個 Callable(game) → Array[Dictionary]
#   目標：{id, kind:"stage"/"king"/"res"/"landmark"/"barracks"/"raid", name, pos:Vector2, my_pow:int, foe_pow:int, icon:String, go:Callable}
extends RefCounted

static var providers := []
