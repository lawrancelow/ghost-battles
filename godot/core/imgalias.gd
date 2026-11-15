# 圖片別名：assets/img/* 同 assets/spr/* 好多係一模一樣嘅圖（抽圖工具抽咗兩次），安裝包只留 spr 嗰份
# JS（Image.src、CSS url()）同原生仍然用舊路徑，經呢度轉去真檔
class_name ImgAlias
extends RefCounted

static var _map = null
static func resolve(p: String) -> String:
	if _map == null:
		_map = {}
		if FileAccess.file_exists("res://data/img_alias.json"):
			var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/img_alias.json"))
			if o is Dictionary: _map = o
	return _map.get(p, p)
