# [landmark] 行動目標登記（ctl 線擁有正式版；呢個係 landmark 線嘅最小版本，整合時以 ctl 版為準）
#   AT.providers：Array of Callable；每個傳入 game 節點、回傳 Array[Dictionary]
#   目標格式：{id, kind:"stage"/"king"/"res"/"landmark"/"barracks"/"raid", name, pos:Vector2(村地圖座標), my_pow, foe_pow, icon, go:Callable}
extends RefCounted

static var providers := []
