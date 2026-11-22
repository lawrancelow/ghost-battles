# 行動目標登記（ctl 線擁有；呢個係 raid 線嘅最小版本，整合時以 ctl 版為準）
# AT.providers：Array of Callable(game) -> Array[Dictionary]
#   {id, kind:"stage"/"king"/"res"/"landmark"/"barracks"/"raid", name, pos:Vector2, my_pow:int, foe_pow:int, icon:String, go:Callable}
extends RefCounted
static var providers := []
