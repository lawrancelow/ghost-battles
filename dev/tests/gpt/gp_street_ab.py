import sys,json; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
JS="""(args)=>{ const [lv, dlv, secs, seed]=args; const T=Street.Turf; cancelAnimationFrame(T.raf);
  let sr=seed; Math.random=()=>{ sr=(sr*16807)%2147483647; return (sr-1)/2147483646; };
  const sd=T.sd; const keep=S.ghosts.map(g=>g.lv); S.ghosts.forEach(g=>{ if(g.k!=='afu') g.lv=lv; g.post=null; });
  // 固定佈置：每格都起設備（牆崗驚嚇、路崗鬼拉腳），設備 Lv dlv；兩隻鬼加持、兩隻有名鬼巡邏
  const NDEV=args[5]; sd.posts=T.lay.posts.map((sp,i)=>i<NDEV?({ g:'dev:'+(sp.h?'scare':'trap'), role:sp.h?'scare':'trap', sz:sp.s||1, lv:dlv, build:0, spent:100, cd:0 }):null);
  const gs=S.ghosts.filter(g=>g.k!=='afu'); const staffK=['xiaozhi','toyol'], bossK=['laojiang','pontianak'];
  let si=0; for(const k of staffK){ const g=gs.find(x=>x.k===k); const p=sd.posts[si++]; p.staff=g.id; g.post='street'; }
  sd.bosses=bossK.map(k=>gs.find(x=>x.k===k).id); T.bosses=[];
  T.walkers=[]; T.q={st:'gap',t:1,n:0,made:0,list:[]}; T.sqPlan=null; T.sqCD=9999; T.eliteT=9999; if(typeof StnFoes!=='undefined') StnFoes.reset();
  const s0=sd.scared, l0=sd.leaked; const dmg={dev:0,boss:0}; const oh=T.hit; T.hit=function(w,d,o){ if(!(w.gone||w.hp<=0)){ if(o&&o.force) dmg.boss+=d; else dmg.dev+=d; } return oh.apply(this,arguments); }; const dt=1/30; let t=0;
  const tst=Fx.toast; Fx.toast=()=>{};
  while(t<secs){ sd.lv=dlv*0+args[4]; sd.hot=0; if(T.q.st==='ready') T.release(true); T.tick(dt); t+=dt; }
  Fx.toast=tst; T.hit=oh;
  const M=T.staffMul(sd.posts[0]), bd=Math.round(T.lore? 0:0);
  const out={scared:sd.scared-s0, leaked:sd.leaked-l0, staffAtk:+M.atk.toFixed(3), staffCd:+M.cd.toFixed(3), pow:GP.pow(gs.find(x=>x.k==='laojiang')), dmgDev:Math.round(dmg.dev), dmgBoss:Math.round(dmg.boss), np:T.lay.posts.length, grow:+GP.grow(gs.find(x=>x.k==='laojiang')).toFixed(3)};
  S.ghosts.forEach((g,i)=>g.lv=keep[i]); return JSON.stringify(out); }"""
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1; Street.open(); Street.Turf.open('market');}"); pg.wait_for_timeout(2500)
    ND=int(sys.argv[1]); DL=int(sys.argv[2]); DS=[int(x) for x in sys.argv[3].split(',')]
    for d in DS:
        for lv in [1,10,20,40]:
            rs=[json.loads(pg.evaluate(JS,[lv,DL,240,seed,d,ND])) for seed in (11,22,33)]
            sc=sum(r['scared'] for r in rs); lk=sum(r['leaked'] for r in rs)
            print(f"路人膽量Lv{d} 鬼Lv{lv}: 嚇走 {sc} 漏 {lk} 嚇走率 {sc/max(1,sc+lk):.0%}  老殭鬼力 {rs[0]['pow']} grow {rs[0]['grow']} 加持(小紙) atk×{rs[0]['staffAtk']} cd×{rs[0]['staffCd']} 設備傷害 {sum(r['dmgDev'] for r in rs)} 有名鬼傷害 {sum(r['dmgBoss'] for r in rs)} 格數 {rs[0]['np']}")
    print('errs',errs[:5]); b.close()
