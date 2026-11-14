# 夜班巡陰（原生）：單位（我方／敵方共用）
class_name PtUnit
extends RefCounted

var side := 0            # 0 我方、1 敵方
var role := ""           # afu / lead / crew / troop（我方）
var g = null             # JS 鬼（Dictionary）
var gid := ""
var k := ""
var name := ""
var fac := "lan"
var hp := 1.0
var maxhp := 1.0
var atk := 1.0
var rng := 46.0
var aspd := 1.0
var spd := 160.0
var cd := 0.0
var energy := 0.0
var sk = null            # SKILLS[k]（Dictionary）或 null
var s := 0.5
var x := 0.0
var y := 0.0
var vx := 0.0
var vy := 0.0
var flip := false
var hurt := 0.0
var flash := 0.0
var moving := false
var act = null           # {ph, t, tg, cast, dur, slam}
var kb := Vector2.ZERO
var leader := false
var slot := 0
var ti := 0
var in_fight := false
var sick := false
var tired := false
var dead_t := 0.0
var gone := false
var wt = null            # 跟隨目標 {x, y, mv}
var wt_t := 0.0
var dash := 0.0
var inv := false
var dash_hit := {}
var wpn = null           # {img, sty, S, lvMul, f}
var cloth = null         # Color
var badge = null         # {col: Color, c}
var swing = null         # {sty, t}
var want_cast := false
var step_t := 0.0
# 敵方
var p := 0.0
var hx := 0.0
var hy := 0.0
var z := -1
var elite := false
var guard := -1
var boss := false
var awake := false
var king := -1
var minion := false
var kname := ""
var bryan := false
var ot := false
var ot_boss := false
var provoked := false
var down := 0.0
var down_max := 4.5
var done := false
var fled := false
var signed := false
var last_by = null
var slam_cd := -1.0
var anim_ph := 0.0

func alive() -> bool: return hp > 0 and not fled and not (down > 0)
