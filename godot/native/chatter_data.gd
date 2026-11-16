# 原生：chatter_data.js 係純數據（碎碎念、性格、入村、對話劇本），由 data/nat/chatter_data.json 讀返（已換走真實品牌名）
extends RefCounted
const DM = preload("res://native/_datamod.gd")
func run(_env) -> void: DM.install("chatter_data")
