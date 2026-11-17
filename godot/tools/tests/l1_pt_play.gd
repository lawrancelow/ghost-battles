# L1：巡陰實玩（原生 patrol 規則＋原生 PatrolMenu 介面）：準備畫面 → 揀主管 → 裝備房（打造）→ 出發 → 收工返村
extends RefCounted

func _p(m): print("[l1pt] ", m)
func _pm(): return PatrolMenu.inst

func prep(_t):
	var S = J.G.S
	if S.get("pt") is Dictionary: S.pt.erase("introSeen")
	J.mc(J.G.Patrol, "openPrep", []); _p("openPrep native=%s" % str(JSRun.native_used.has("patrol")))
func intro_done(_t):
	_p("introSeen=%s menu=%s open=%s" % [str(J.G.S.pt.get("introSeen")), str(J.gp(J.G.Patrol, "_menu") != null), str(_pm() != null and _pm().is_open())])
func lead(_t):
	_pm().pick_lead(0); _p("pick_lead open")
func lead_set(_t):
	var M = J.gp(J.G.Patrol, "_menu"); var p = J.mc(M, "st", [])
	var list = J.G.S.ghosts.filter(func(x): return J.str(x.get("q")) == "名")
	J.sp(p, "lead", [list[0].id] if list.size() else []); J.cl(J.G.save, null, []); _pm()._render_prep()
	_p("lead=%s leads=%s" % [str(p.lead), str(J.mc(M, "leads", []).map(func(g): return g.id))])
func gear(_t):
	_pm().open_gear(); _p("gear open")
func craft(_t):
	var GM = J.gp(J.G.Gear, "_menu"); var S = J.G.S
	S.res.coins = maxf(S.res.coins, 5000.0); S.res.planks = maxf(S.res.planks, 500.0); S.pt.mats.yuan = maxf(J.num(S.pt.mats.get("yuan")), 50.0)
	var cc = J.mc(GM, "craftCost", [0.0, "yuan"])
	var ok = J.mc(GM, "canPayAll", [cc])
	if ok:
		J.mc(GM, "payAll", [cc]); var s = J.mc(GM, "st", []); var uid = J.num(s.uid); s.uid = uid + 1
		s.items.append({"id": "e%d" % int(uid), "slot": "wea", "c": 0.0, "f": "yuan", "lv": 1.0, "who": "afu"})
		J.cl(J.G.save, null, [])
	var w = J.mc(J.G.Gear, "weaponOf", [J.cl(J.G.ghostById, null, ["afu"])])
	_p("craft ok=%s items=%d weaponOf(afu)=%s gpMul=%s" % [str(ok), J.mc(GM, "st", []).items.size(), str(w.img) if w else "null", str(J.mc(J.G.Gear, "gpMul", [J.cl(J.G.ghostById, null, ["afu"])]))])
	_pm()._show_gear(true)
func go(_t):
	_pm().go(0, 54.0); _p("go")
func run_state(_t):
	_p("PtRun=%s active=%s" % [str(PtRun.cur != null), str(J.gp(J.G.Patrol, "active"))])
func quit(_t):
	if PtRun.cur: PtRun.cur.end(false); _p("end")
func close(_t):
	if PtRun.cur: PtRun.cur.close_run(); _p("close_run")
func back(_t):
	_p("after: PtRun=%s active=%s pt.min=%s kills=%s" % [str(PtRun.cur != null and is_instance_valid(PtRun.cur)), str(J.gp(J.G.Patrol, "active")), str(J.G.S.pt.get("min")), str(J.G.S.pt.get("kills"))])
