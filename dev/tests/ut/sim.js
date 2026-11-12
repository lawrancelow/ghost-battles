const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat', nights=+(process.argv[3]||3), seed=+(process.argv[4]||1); const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(([nights,seed])=>{
    let s=seed; const R=()=>{ s=(s*16807)%2147483647; return (s-1)/2147483646; };
    const out={nights:[],viol:[]}; UNIT.manual=true; TW.pause(true);
    const V=(m)=>{ if (out.viol.length<30) out.viol.push(m); };
    for (let n=0;n<nights;n++){
      const G=TW.G; const st={enters:0,kicks:0,timeouts:0,exits:0,hots:0,scares:0,tasks:0,fled:0,maxIn:0,steps:0};
      const fledSeen=new Set(); const prevState=new Map(); let inT=0, wasIn=false, act=0;
      const allRes=()=>G.units.reduce((a,u)=>a.concat(u.rs||[]),[]);
      allRes().forEach(r=>prevState.set(r,r.state));
      const fear0=G.fearTotal;
      for (let k=0;k<2400;k++){ st.steps++;
        if (G.choice) TW.choose(0);
        if (G.over) break;
        TW.step(0.1,1); UNIT.step(0.1);
        const g=G.gh[G.active], S=UNIT._S();
        // 不變式
        const nums=[G.fear,G.fearTotal,G.alert,G.t]; G.res.forEach(r=>nums.push(r.fear||0)); if (S) nums.push(S.alert,S.gx,S.limit,S.cam.x);
        if (nums.some(x=>typeof x!=='number'||!isFinite(x))) V('NaN at '+k);
        const inC=G.gh.filter(x=>x.inUnit).length; if (inC>1) V('two ghosts inside'); if ((inC===1)!==!!S) V('inUnit mismatch '+inC+' '+!!S);
        if (S){ const set=new Set(); S.actors.forEach(a=>{ if (set.has(a.r)) V('dup actor'); set.add(a.r); if (S.un.rs.indexOf(a.r)<0) V('foreign actor'); }); if (S.alert>100.01||S.alert<0) V('alert range '+S.alert); }
        allRes().forEach(r=>{ const p=prevState.get(r); if (p!==r.state){ if (r.state==='flee'){ if (fledSeen.has(r)) V('double flee'); fledSeen.add(r); st.fled++; } if ((p==='flee'||p==='gone')&&r.state==='home') V('fled came back'); prevState.set(r,r.state); } });
        if (new Set(G.story).size!==G.story.length) V('dup story');
        const done=G.units.filter(u=>u.iu&&u.iu.done).length; if ((G.unitTasks||0)!==done) V('task count '+G.unitTasks+' vs '+done); if ((G.unitCoins||0)!==15*done) V('coins');
        // 逗留時間
        if (S){ inT+=0.1; st.maxIn=Math.max(st.maxIn,inT); if (inT>90) V('stuck inside '+inT); } else inT=0;
        if (wasIn&&!S){ st.exits++; } wasIn=!!S;
        // 代理人
        act-=0.1; if (act>0) continue; act=0.4+R()*0.8;
        if (!S){ if (g.home||g.out){ const nx=G.gh.find(x=>!x.home&&!x.out); if (nx) G.active=nx.i; continue; }
          const cand=G.units.filter(u=>u.hh&&u.ot!=='deity'&&UNIT.canEnter(g,u)); if (!cand.length||R()<0.15) continue;
          const u=cand[Math.floor(R()*cand.length)]; const d=G.nodes[u.did]; g.node=u.did; g.to=null; g.auto=null; g.x=d.x; g.y=d.y;
          if (UNIT.enterFromDoor(g,u)) st.enters++; continue; }
        const x=R();
        if (x<0.30){ const i=Math.floor(R()*S.spots.length); if (UNIT.trig(i)) st.hots++; }
        else if (x<0.55){ if (UNIT.scare()) st.scares++; }
        else if (x<0.75){ S.goX=S.lay.rooms[0].x0+R()*(S.lay.rooms[S.lay.rooms.length-1].x1-S.lay.rooms[0].x0); }
        else if (x<0.82){ if (S.task.k==='steal'&&!S.task.done) S.goX=S.task.x; }
        else if (x<0.86){ UNIT.press('inv'); }
        else if (x<0.88){ UNIT.press('out'); }
        else if (x<0.90){ UNIT.press('room'+Math.floor(R()*4)); }
      }
      // 記錄 kick／timeout：由 un.iu
      G.units.forEach(u=>{ if (u.iu){ st.tasks+=u.iu.done?1:0; } });
      st.fearGain=G.fearTotal-fear0; st.unitTasks=G.unitTasks||0; st.coins=G.unitCoins||0; st.t=Math.round(G.t); st.alert=G.alert; st.err=UNIT._err||null;
      out.nights.push(st);
      // 收尾：替身遁走，開新一晚
      if (UNIT._S()) UNIT.exit('door');
      if (!G.over){ G.dolls=6; TW.doll(); }
      if (G.over){ const rw=G.over.reward; st.reward=rw; } 
      TW.press('again');
    }
    TW.pause(false); UNIT.manual=false; return out; },[nights,seed]);
  console.log(lv,JSON.stringify(r)); console.log('ERRS',errs); await b.close(); })();
