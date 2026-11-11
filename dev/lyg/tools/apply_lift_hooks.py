# 將電梯 LIFT HOOK 插入 pangsa.js 嘅副本（唔改原檔），再砌一個測試用 HTML。
# 用法：python3 tools/apply_lift_hooks.py [輸出js] [輸出html]
#   預設：/tmp/claude-0/lift/pangsa_lift.js、/tmp/claude-0/out/GhostTower_Lift.html
import sys, os, json, base64
D=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOOKS=[
 # (錨點句, 插入位置 'before'/'after', 插入代碼)
 ("    if (n.kind==='lift'&&LV.lift&&(G.liftCd||0)<=0) return {k:'lift',t:'叫𨋢自己上落'};", 'before',
  "    if (LIFT){ var la=LIFT.action(g,n); if (la) return la; }   // LIFT HOOK 2：𨋢口出「入𨋢」\n"),
 ("    if (g.still<0.1){ float(g.x,g.y-80,'鬆手企定先做得','#ffd54a'); return; }", 'after',
  "\n    if (a.k==='liftIn'){ LIFT.enter(g); return; }   // LIFT HOOK 3：入𨋢／叫𨋢"),
 ("  window.TW={", 'before',
  "  // LIFT HOOK 1：電梯系統（core/lift.js）接駁——只係將閉包變數交俾模組，模組自己行 rAF\n"
  "  var LIFT=window.LiftSys?window.LiftSys({get G(){return G;}, get LV(){return LV;}, get FL(){return FL;}, get FLN(){return FLN;}, get IMG(){return IMG;}, get scene(){return scene;}, get paused(){return paused;},\n"
  "    get VW(){return VW;}, get VH(){return VH;}, get TOP(){return TOP;}, get BOT(){return BOT;}, FONT:FONT, HUM:HUM, HH:HH, cv:cv, fy:fy, rnd:rnd, float:float, toast:toast, say:say, addFear:addFear, noise:noise, spook:spook, W2S:W2S}):null;\n"
  "  window.LIFT=LIFT;\n"),
]
def patch(s):
    if 'LIFT HOOK' in s: return s
    for a,pos,code in HOOKS:
        assert s.count(a)==1,('錨點唔見／唔唯一',a[:70],s.count(a))
        s=s.replace(a,(code+a) if pos=='before' else (a+code))
    return s
if __name__=='__main__':
    oj=sys.argv[1] if len(sys.argv)>1 else '/tmp/claude-0/lift/pangsa_lift.js'
    oh=sys.argv[2] if len(sys.argv)>2 else '/tmp/claude-0/out/GhostTower_Lift.html'
    s=patch(open(f'{D}/src/pangsa.js',encoding='utf-8').read())
    os.makedirs(os.path.dirname(oj),exist_ok=True); open(oj,'w',encoding='utf-8').write(s)
    # 同 build_play.py 一樣砌法，另外將 core/lift.js 放喺 /*SIM*/ 位（喺遊戲之前載入）
    keys=['room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby','res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','npc_it_sit','npc_ken_sit','eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_auntie','npc_guard','npc_it','npc_mis','npc_boss','flatbg','shopbg']
    img={k:'data:image/webp;base64,'+base64.b64encode(open(f'{D}/assets/{k}.webp','rb').read()).decode() for k in keys if os.path.exists(f'{D}/assets/{k}.webp')}
    h=open(f'{D}/src/shell.html',encoding='utf-8').read().replace('<title>楼里有鬼</title>','<title>樓裡有鬼・組屋關</title>').replace('lang="zh-CN"','lang="zh-HK"')
    h=h.replace('/*IMG*/','window.LYG_IMG='+json.dumps(img)+';').replace('/*DATA*/','').replace('/*SIM*/',open(f'{D}/core/lift.js',encoding='utf-8').read()).replace('/*GAME*/',s)
    os.makedirs(os.path.dirname(oh),exist_ok=True); open(oh,'w',encoding='utf-8').write(h); print('patched',oj,'built',oh,len(h))
