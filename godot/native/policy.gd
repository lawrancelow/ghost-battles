# 原生改寫自 policy.js（新政策發佈會：龐總講《陽間業務拓展計劃》，第一次入站崗／樓裡有鬼嘅提示框）
# 介面同轉譯版一樣：J.G["Policy"] = { announce, maybe, firstEnter, TIPS }；tools/jsgd/patches.js 嘅 policy 補丁效果已包括
extends RefCounted

const BOSS := "npc_kpiboss"
const A := [
	["旁白", "陰間集團總部，三樓會議室。投影機風扇嘅聲，大過成個部門。"],
	["龐總", "各位，今日召開新政策發佈會。我只講一次，重複係浪費 resources。", "ag:tap"],
	["阿福", "成間會議室得我一個，你叫「各位」？"],
	["龐總", "我係對住未來嘅編制講。下季呢度坐唔坐得滿，睇你啲數。"],
	["龐總", "本集團正式推出《陽間業務拓展計劃》。陰間市場已經飽和，增長要去陽間搵。", "ag:yell"],
	["阿福", "講人話啦。"],
	["龐總", "即係去陽間嚇人。第一條：「陽間站崗」。"],
	["龐總", "陽間有幾個地盤，我已經 secure 咗位。你派鬼過去企位，路人行過就嚇佢。"],
	["阿福", "企邊度有冇得揀㗎？"],
	["龐總", "睇格仔。咩類型嘅格，就擺咩鬼。擺錯位，叫做資源錯配。"],
	["阿福", "咁我啲小鬼，可唔可以一隻擺幾次？"],
	["龐總", "普通鬼大把，重複擺冇問題。有名有姓嗰啲就唔同，一張地圖最多三隻，仲可以同設備勵鬼加持——物以罕為貴。"],
	["阿福", "即係佢哋人工高啲？"],
	["龐總", "即係佢哋要求多啲。另外，鬼嚇人會儲能量，儲滿就放大招，一嚇嚇一堆。呢個叫規模效應。", "ag:tap"],
	["阿福", "嚇完一間房，咪收得工囉？"],
	["龐總", "收工？嚇得夠多，地圖會延伸，第二間、第三間房陸續開放。業務係要擴張嘅。"],
	["龐總", "（指住窗外塊地圖）自己望吓。"],
]
const A_MAP := [["龐總", "就係呢張卡：陽間站崗。"], ["阿福", "個框閃到咁，想睇唔到都難。"]]
const B := [
	["龐總", "第二條：「樓裡有鬼」。呢條係我哋嘅 premium 產品線。", "ag:tap"],
	["阿福", "又 premium？上次 premium 係加班冇補水。"],
	["龐總", "你揀一棟樓，組屋又得，老店屋又得，由地下開始，一層一層向上嚇住戶。"],
	["阿福", "由下而上，好似升職咁喎。"],
	["龐總", "升職係由上而下指派嘅，唔好亂比喻。重點：鬼要企定先出得手，郁緊嘅鬼嚇唔到人。", "ag:sigh"],
	["阿福", "同返工一樣，要坐定定扮忙。"],
	["龐總", "仲有，見到門口有門神，或者貼住紅紙符，一律繞路。"],
	["阿福", "唔可以硬闖？"],
	["龐總", "唔可以。門神係守住戶嘅，神明要尊重。呢條係公司紅線，唔係 KPI，冇得 negotiate。"],
	["阿福", "難得你都有一樣嘢係尊重嘅。"],
	["龐總", "最後，開工時間係子時到寅時。天光之前，一定要返到陰間。"],
	["阿福", "遲咗會點？"],
	["龐總", "遲咗你就變晨運阿伯嘅話題。公司唔會幫你報工傷。", "ag:yell"],
]
const B_MAP := [["龐總", "呢張就係樓裡有鬼。揀棟樓，由地下嚇上去。"], ["阿福", "睇落層數唔少喎……"]]
const C := [
	["龐總", "總結：兩條產品線同步推進。本季 KPI，陽間嚇人數字要按月增長。", "ag:tap"],
	["阿福", "增長幾多？"],
	["龐總", "比上個月多。上個月係零，所以你做幾多都算增長——呢個就係領導藝術。"],
	["阿福", "……你第一次講咗句對我有著數嘅嘢。"],
	["龐總", "唔好誤會。下個月嘅 baseline，就係你今個月嘅數字。散會。", "ag:sigh"],
	["旁白", "投影機熄咗。風扇聲仲響緊。"],
]
const TIPS := {
	"station": [
		"站崗守則第一條：橙色格係路崗，放鬼拉腳、鬼打牆、卡到陰；紫色格貼牆，放驚嚇、氛圍、投擲。",
		"鬼打牆一圍，路人原地兜圈搵唔到路；佢哋合力衝破咗，要等佢重新圍返。",
		"升級要冥幣，唔夠錢個掣會灰咗。回靈速度愈快，出手愈密。",
		"雜鬼或者名鬼可以幫設備勵鬼加持，名鬼加持最勁。",
		"紙皮箱、手推車會擋住視線；保安阿伯嘅電筒會照停你啲設備，小心佢。",
	],
	"tower": [
		"由地下開始，一層一層向上嚇，唔好跳級。",
		"鬼企定咗先出得手，郁緊嘅唔計數。",
		"見到門神同紅紙符就繞路——神明要尊重，唔准亂嚟。",
		"子時開工，寅時前一定要返陰間，天光就遲。",
	],
}
const ROOTS := {"station": "#st-street", "tower": "#tw-root"}
const CSS := """
.wm-pol{margin-left:auto;flex:none;padding:6px 10px;border-radius:10px;border:2px solid #6b3b1f;background:rgba(248,232,196,.95);color:#3a2212;font-family:inherit;font-size:14px;font-weight:700;box-shadow:0 3px 10px rgba(0,0,0,.45);white-space:nowrap}
#pol-ov{position:absolute;inset:0;z-index:50;background:rgba(10,8,14,.25)}
#pol-ov .pol-ring{position:absolute;border-radius:18px;pointer-events:none;box-shadow:0 0 0 3px #ffd36a,0 0 18px 6px rgba(255,200,90,.85);animation:polPulse 1.1s ease-in-out infinite}
@keyframes polPulse{50%{box-shadow:0 0 0 3px #fff1b8,0 0 28px 10px rgba(255,210,110,.95)}}
#pol-ov .pol-arr{position:absolute;width:0;height:0;margin-left:-10px;border:10px solid transparent;border-top:13px solid #ffd36a;border-bottom:0;filter:drop-shadow(0 2px 3px rgba(0,0,0,.6));pointer-events:none;animation:polBob .8s ease-in-out infinite}
@keyframes polBob{50%{transform:translateY(6px)}}
.pol-box{position:absolute;left:16px;right:16px;padding:10px 14px 12px;background:#f6ecd2;color:#2a1a10;border-radius:14px;box-shadow:0 0 0 2px #3a2a1a,0 6px 16px rgba(0,0,0,.55);font-size:18px;line-height:1.5;font-weight:700;overflow-wrap:anywhere}
.pol-box b{display:block;font-family:var(--serif);font-size:14px;font-weight:900;color:var(--cinnabar,#b0302a);margin-bottom:2px;letter-spacing:1px}
.pol-box small{display:block;text-align:right;font-size:12px;font-weight:400;color:#8a6a4a;margin-top:2px}
#pol-tip{position:fixed;z-index:100050;bottom:calc(env(safe-area-inset-bottom) + 10px);font-size:16px;padding:8px 12px 9px;background:rgba(246,236,210,.96);cursor:pointer}
"""

static var busy := false

static func _g(n: String): return J.G.get(n)
static func _doc(): return _g("document")
static func _byid(id: String): return J.S_document_("getElementById", [id])
static func _tr(t: String) -> String:
	var Lf = _g("L")
	return J.str(J.cl(Lf, null, [t])) if J.typeof_(Lf) == "function" else t
static func _later(ms: float, f: Callable) -> void: J.F_setTimeout([func(_t, _a): f.call(); return null, ms])
static func _click() -> void:
	var Snd = _g("Sound")
	if J.t(J.gp(Snd, "play")): J.mc(Snd, "play", ["click"])
static func _stop(a: Array) -> void:
	var e = J.arg(a, 0)
	if J.t(e) and J.t(J.gp(e, "stopPropagation")): J.mc(e, "stopPropagation", [])

static func cast() -> Array: return [["阿福", "afu"], ["龐總", BOSS, {"base": "ag:inspect", "talk": "ag:tap"}]]
static func seen(k: String) -> bool:
	var S = _g("S")
	return J.t(S) and J.t(J.gp(S, "seen")) and J.t(J.gp(J.gp(S, "seen"), k))
static func mark(k: String) -> void:
	var S = _g("S")
	if not J.t(S): return
	if not J.t(J.gp(S, "seen")): J.sp(S, "seen", {})
	J.sp(J.gp(S, "seen"), k, true)
	J.cl(_g("save"), null, [])

static func _lines(src: Array) -> Array: return src.duplicate(true)

static func stage(title: String, lines: Array, cb: Callable) -> void:
	J.mc(_g("Theater"), "play", [{"tag": "新政策", "title": title, "bg": "hq", "cast": cast(), "lines": lines}, func(_t, _a): cb.call(); return null])

# ---------- 喺地圖上指住張卡（外框發光＋箭咀，唔遮卡）----------
static func point(id: String, lines: Array, cb: Callable) -> void:
	var wm = _byid("world")
	var card = J.mc(wm, "querySelector", [".wm-card[data-id=\"%s\"]" % id]) if J.t(wm) else null
	if not J.t(card): cb.call(); return
	J.mc(card, "scrollIntoView", [{"block": "nearest"}])
	var host = _byid("app")
	if not J.t(host): host = J.gp(_doc(), "body")
	var ov = _byid("pol-ov")
	if J.t(ov): J.mc(ov, "remove", [])
	ov = J.S_document_("createElement", ["div"]); J.sp(ov, "id", "pol-ov"); J.sp(J.gp(ov, "dataset"), "card", id); J.mc(host, "appendChild", [ov])
	var hr = J.mc(ov, "getBoundingClientRect", []); var r = J.mc(card, "getBoundingClientRect", [])
	var x = J.num(J.gp(r, "left")) - J.num(J.gp(hr, "left")); var y = J.num(J.gp(r, "top")) - J.num(J.gp(hr, "top")); var pad = 5.0
	var rw = J.num(J.gp(r, "width")); var rh = J.num(J.gp(r, "height"))
	J.sp(ov, "innerHTML", "<i class=\"pol-ring\" style=\"left:%spx;top:%spx;width:%spx;height:%spx\"></i>\n      <i class=\"pol-arr\" style=\"left:%spx;top:%spx\"></i><div class=\"pol-box\"><b></b><span></span><small>撳一下繼續 ▸</small></div>" % [J.str(x - pad), J.str(y - pad), J.str(rw + pad * 2), J.str(rh + pad * 2), J.str(x + rw / 2), J.str(y - pad - 14)])
	var box = J.mc(ov, "querySelector", [".pol-box"])
	var st = {"i": 0}
	var show = func():
		var ln = lines[st.i]
		J.sp(J.mc(box, "querySelector", ["b"]), "textContent", ln[0])
		J.sp(J.mc(box, "querySelector", ["span"]), "textContent", _tr(ln[1]))
		# 對白框放喺卡板上面（地圖位），唔遮任何卡；位唔夠先放喺卡下面
		var bd = J.mc(wm, "querySelector", [".wm-board"])
		var bt = J.num(J.gp(J.mc(bd, "getBoundingClientRect", []), "top")) - J.num(J.gp(hr, "top")) if J.t(bd) else y - pad - 30
		var bh = J.num(J.gp(box, "offsetHeight")); var above = minf(bt, y - pad - 20) - bh - 8
		if above >= 56: J.sp(J.gp(box, "style"), "top", J.str(above) + "px"); J.sp(J.gp(box, "style"), "bottom", "")
		else: J.sp(J.gp(box, "style"), "top", J.str(y + rh + pad + 12) + "px")
	show.call()
	var t0 = J.num(J.S_performance_("now", []))
	J.sp(ov, "onclick", func(_t, a):
		_stop(a)
		if J.num(J.S_performance_("now", [])) - t0 < 350: return null
		_click()
		st.i += 1
		if st.i < lines.size(): show.call()
		else: J.mc(ov, "remove", []); cb.call()
		return null)

static func announce() -> void:
	if busy or _g("Theater") == null: return
	busy = true
	var end = func(): busy = false
	var has_tower = func(): return J.t(J.S_document_("querySelector", ["#world .wm-card[data-id=\"tower\"]"]))
	stage("新政策發佈會", _lines(A), func(): point("station", _lines(A_MAP), func():
		var b = _lines(B)
		if has_tower.call(): b.append(["龐總", "地圖上面有張新卡，自己搵。"])
		stage("《陽間業務拓展計劃》", b, func(): point("tower", _lines(B_MAP), func(): stage("KPI", _lines(C), end)))))

static func maybe() -> void:
	var S = _g("S")
	if not J.t(S) or not J.t(J.gp(S, "seen")): return
	var sn = J.gp(S, "seen")
	if not (J.t(J.gp(sn, "ch1_end")) or J.t(J.gp(_g("window"), "STN_TEST"))) or J.t(J.gp(sn, "policy_v1")): return
	mark("policy_v1")
	_later(600.0, func():
		if J.t(J.S_document_("querySelector", ["#world.on"])) and not J.t(J.gp(_g("Theater"), "on")): announce())

# ---------- 第一次入玩法：底部細框 ----------
static func first_enter(mode) -> void:
	var m = J.str(mode); var k = "policy_" + m
	if not TIPS.has(m) or seen(k): return
	var tips: Array = TIPS[m]
	mark(k)
	_later(500.0, func():
		var el = _byid("pol-tip")
		if J.t(el): J.mc(el, "remove", [])
		el = J.S_document_("createElement", ["div"]); J.sp(el, "id", "pol-tip"); J.sp(el, "className", "pol-box")
		var body = J.gp(_doc(), "body")
		J.mc(body, "appendChild", [el])
		var st = {"i": 0}
		var show = func():
			J.sp(el, "innerHTML", "<b>龐總（%d/%d）</b><span></span><small>撳一下%s ▸</small>" % [st.i + 1, tips.size(), "下一句" if st.i + 1 < tips.size() else "收埋"])
			J.sp(J.mc(el, "querySelector", ["span"]), "textContent", _tr(tips[st.i]))
		show.call()
		J.sp(el, "onclick", func(_t, a):
			_stop(a); _click()
			st.i += 1
			if st.i < tips.size(): show.call()
			else: J.mc(el, "remove", [])
			return null)
		# 所有玩法：一撳提示以外嘅地方就收起，唔遮住遊戲
		var off_ref = {}
		var off = func(_t, a):
			var ev = J.arg(a, 0)
			if not J.t(J.mc(body, "contains", [el])): J.S_document_("removeEventListener", ["pointerdown", off_ref.f, true]); return null
			if not J.t(J.mc(el, "contains", [J.gp(ev, "target")])): J.mc(el, "remove", []); J.S_document_("removeEventListener", ["pointerdown", off_ref.f, true])
			return null
		off_ref["f"] = off
		J.S_document_("addEventListener", ["pointerdown", off, true])
		# 離開咗嗰個玩法（畫面收埋）就即刻收起提示；原生站崗冇 #st-street DOM，問原生畫面仲開唔開
		var wt_ref = {}
		wt_ref["id"] = J.F_setInterval([func(_t, _a):
			if not J.t(J.mc(body, "contains", [el])): J.F_clearInterval([wt_ref.id]); return null
			var r = J.S_document_("querySelector", [ROOTS.get(m, "#none")])
			var nst = _g("__nat_stOn")
			var vis = (m == "station" and nst != null and J.t(J.cl(nst, null, []))) or (J.t(r) and J.t(J.mc(J.gp(r, "classList"), "contains", ["on"])) and J.str(J.gp(J.F_getComputedStyle([r]), "display")) != "none")
			if not vis: J.mc(el, "remove", []); J.F_clearInterval([wt_ref.id])
			return null, 400.0]))

func run(_env) -> void:
	busy = false
	if not J.t(_byid("pol-css")):
		var s = J.S_document_("createElement", ["style"]); J.sp(s, "id", "pol-css"); J.sp(s, "textContent", CSS)
		J.mc(J.gp(_doc(), "head"), "appendChild", [s])
	var P = {
		"announce": func(_t, _a): announce(); return null,
		"maybe": func(_t, _a): maybe(); return null,
		"firstEnter": func(_t, a): first_enter(J.arg(a, 0)); return null,
		"TIPS": TIPS.duplicate(true),
	}
	J.G["Policy"] = P
	var w = J.G.get("window")
	if w != null: J.sp(w, "Policy", P)
