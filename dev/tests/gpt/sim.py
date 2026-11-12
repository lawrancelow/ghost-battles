import sys,json; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
JS="""(args)=>{const [Ls,trials,team]=args; const out={};
 const of=Battle.finish; let res=null; Battle.finish=function(win){res=win; this.result={win}; this.active=false;};
 const ss=Sound.play; Sound.play=()=>{};
 const keep=S.ghosts.map(g=>g.lv), keepLv=S.lv, keepT=S.res.troops, keepTeam=S.team.slice(), keepAd=S.adviser;
 const ids=team.map(k=>{let g=S.ghosts.find(x=>x.k===k); if(!g){joinGhost(k); g=S.ghosts.find(x=>x.k===k);} return g.id;});
 S.team=ids; S.adviser=null;
 CHAPTERS.forEach((ch,ci)=>ch.stages.forEach((st,si)=>{ const sid=Battle.sidOf(ci,si); out[sid]={};
   for(const L of Ls){ let w=0; for(let t=0;t<trials;t++){ S.lv=st.req; S.res.troops=100; for(const id of ids){S.ghosts.find(g=>g.id===id).lv=L;} res=null; Battle.auto=true; Battle.speed=1;
      Battle.start(ci,si); let n=0; while(res===null && n<30*200){ Battle.update(1/30); n++; } if(res) w++; }
     out[sid][L]=w; } }));
 S.ghosts.forEach((g,i)=>g.lv=keep[i]); S.lv=keepLv; S.res.troops=keepT; S.team=keepTeam; S.adviser=keepAd; Battle.finish=of; Sound.play=ss; Battle.active=false; document.getElementById('battle').classList.remove('on');
 const pw={}; for(const L of Ls){ pw[L]=Math.round(ids.reduce((a,id)=>{const g=S.ghosts.find(x=>x.id===id); const o=g.lv; g.lv=L; const v=GP.pow(g); g.lv=o; return a+v;},0)/ids.length); }
 return JSON.stringify({out,pw});}"""
team=sys.argv[1].split(',') if len(sys.argv)>1 else ['xiaozhi','eguiking','laojiang']
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    r=json.loads(pg.evaluate(JS,[[1,3,5,7,9,11,13,15,17,20,24,28,32,36,40],3,team]))
    print('pow',r['pw'])
    for sid,v in r['out'].items():
        mn=next((L for L,w in v.items() if w>=2),None)
        print(sid, v, 'min', mn)
    print(errs[:5]); b.close()
