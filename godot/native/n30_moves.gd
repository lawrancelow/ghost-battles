# 原生改寫自 n30_moves.js：30 隻新鬼（n30_*）嘅專屬招式
# 招式本體喺 game/battle/bt_n30*.gd（原生主線戰鬥同一份，工具 N30K 對應 BtN30）；呢度登記入 MOVES
# N30K／N30M 全局照留（npc_antag 嘅網格動作仲用緊 N30K）：先跑轉譯版攞工具，招式再換原生
extends RefCounted
const MV := preload("res://native/moves.gd")
const KEYS := ["n30_diaosi", "n30_wutou", "n30_yecha", "n30_hanba", "n30_changgui", "n30_guixinniang", "n30_shanxiao", "n30_baigujing", "n30_qionggui", "n30_dugui", "n30_jiugui", "n30_yangui", "n30_guhangui", "n30_taozhai", "n30_danxiao", "n30_maoshi", "n30_hanturaya", "n30_polong", "n30_pelesit", "n30_jenglot", "n30_hantugalah", "n30_jerangkung", "n30_genderuwo", "n30_bunian", "n30_maenak", "n30_phiam", "n30_churel", "n30_vetala", "n30_kappa", "n30_rokurokubi", "n30_kuchisake", "n30_yukionna", "n30_kasaobake", "n30_nopperabo", "n30_chochin", "n30_gashadokuro", "n30_banshee", "n30_hannya", "n30_aswang", "n30_tikbalang", "n30_chehuo", "n30_diansi", "n30_dongsi", "n30_yezi", "n30_liulian", "n30_yesi", "n30_xiaosi", "n30_xiasi", "n30_leipi", "n30_zipai", "n30_zhongshu", "n30_chengsi", "n30_shedu", "n30_shidu", "n30_daji", "n30_xiangcai"]

static var _kit = null

func run(_env) -> void:
	_kit = load("res://jsgen/n30_moves.gd").new(); _kit.run(null)
	MV.register(KEYS)
