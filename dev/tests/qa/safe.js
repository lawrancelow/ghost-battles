// B：安全區（f0_e）— 3 晚加速模擬，逐幀量保安距離；鬼企喺初始點唔會被捉
const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat', nights=+(process.argv[3]||3); const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate((nights)=>{ let s=7; const R=()=>{ s=(s*16807)%2147483647; return (s-1)/2147483646; };
    UNIT.manual=true; TW.pause(true); const out={R:null,nights:[],viol:[],catchTest:[]}; const V=m=>{ if (out.viol.length<40) out.viol.push(m); };
    for (let n=0;n<nights;n++){ const G=TW.G; const SF=TW.safe?TW.safe():null; const c=G.nodes.f0_e; const RR=SF?SF.r:150; out.R=RR;
      const portals=Object.values(G.nodes).filter(q=>q.kind==='portal'&&q.id!=='f0_e');
      const st={steps:0,minDx:1e9,minPortal:1e9,inSafeSteps:0,fleeIn:0,safeOffSteps:0,caughtInSafe:0,guardsMax:0}; let act=0;
      const nodes=Object.values(G.nodes).filter(q=>q.kind!=='in'&&q.kind!=='portal');
      // 強制測試：鬼企喺 f0_e，保安喺安全區邊追
      const g=G.gh.find(q=>!q.out)||G.gh[0]; g.home=false; g.out=false; g.inv=0; g.stun=0; g.node='f0_e'; g.to=null; g.auto=null; g.x=c.x; g.y=c.y; G.active=g.i;
      const edge=Object.values(G.nodes).filter(q=>q.f===c.f&&q.kind!=='in'&&q.kind!=='portal'&&Math.abs(q.x-c.x)>RR).sort((a,b)=>Math.abs(a.x-c.x)-Math.abs(b.x-c.x))[0];
      const hs=G.guards.filter(h=>h.state!=='gone'&&h.state!=='flee').slice(0,2); hs.forEach(h=>{ h.node=edge.id; h.to=null; h.p=0; h.x=edge.x; h.y=edge.y; h.path=null; h.state='chase'; h.wait=0; h.lostT=0; h.balkCd=0; h.catchCd=0; h.dir=c.x>edge.x?1:-1; });
      const c0=g.caught; let minD=1e9, enter=0;
      for (let k=0;k<200;k++){ G.t=Math.min(G.t,60); g.x=c.x; g.y=c.y; g.node='f0_e'; g.to=null; g.inv=0; TW.step(0.1,1); hs.forEach(h=>{ if (Math.abs(h.y-c.y)<30){ const d=Math.abs(h.x-c.x); minD=Math.min(minD,d); if (d<=RR&&h.state!=='flee') enter++; } }); }
      const ct={edge:edge.id, edgeDx:Math.round(Math.abs(edge.x-c.x)), guardsStates:hs.map(h=>h.state), caughtDelta:g.caught-c0, minGuardDx:Math.round(minD), enterSteps:enter};
      const c1=g.caught; try{ TW.catchG(g.i); }catch(e){} ct.directCatchG=g.caught-c1; g.caught=c1;
      // 巡邏：保安放喺 f0 安全區邊巡 40 秒（鬼隱身）
      G.gh.forEach(q=>q.inv=1e9); let pin=0, pmin=1e9; hs.forEach(h=>{ h.node=edge.id; h.to=null; h.p=0; h.x=edge.x; h.y=edge.y; h.path=null; h.state='patrol'; h.wait=0; h.zone=null; });
      for (let k=0;k<400;k++){ G.t=Math.min(G.t,60); TW.step(0.1,1); hs.forEach(h=>{ if (Math.abs(h.y-c.y)<30){ const d=Math.abs(h.x-c.x); pmin=Math.min(pmin,d); if (d<=RR&&h.state!=='flee'&&(!TW.safe||TW.safe().on)) pin++; } }); }
      ct.patrolMinDx=Math.round(pmin); ct.patrolEnterSteps=pin; G.gh.forEach(q=>{q.inv=0;q.caught=0;q.stun=0;}); G.t=0;
      out.catchTest.push(ct);       for (let k=0;k<2400;k++){ st.steps++; if (G.choice) TW.choose(0); if (G.over) break;
        const pre=G.gh.map((g,i)=>({x:g.x,y:g.y,node:g.node,to:g.to,c:g.caught,inS:TW.inSafe?TW.inSafe(i):(Math.abs(g.y-c.y)<30&&Math.abs(g.x-c.x)<=RR)}));
        TW.step(0.1,1); if (UNIT._S&&UNIT._S()) UNIT.exit('door');
        const on=SF?TW.safe().on:true; if (!on) st.safeOffSteps++;
        st.guardsMax=Math.max(st.guardsMax,G.guards.length);
        G.guards.forEach((h,hi)=>{ if (h.state==='gone') return; const dy=Math.abs(h.y-c.y), dx=Math.abs(h.x-c.x);
          if (dy<30) st.minDx=Math.min(st.minDx,dx);
          portals.forEach(p=>{ if (Math.abs(h.y-p.y)<30) st.minPortal=Math.min(st.minPortal,Math.abs(h.x-p.x)); });
          if (on&&dy<30&&dx<=RR){ if (h.state==='flee') st.fleeIn++; else { st.inSafeSteps++; V('n'+n+' k'+k+' '+h.kind+' '+h.state+' x='+Math.round(h.x)+' dx='+Math.round(dx)); } } });
        G.gh.forEach((g,i)=>{ if (pre[i].inS&&g.caught>pre[i].c&&!(TW.inSafe?TW.inSafe(i):true)){ st.edgeCatch=(st.edgeCatch||0)+1; } if (pre[i].inS&&g.caught>pre[i].c&&(TW.inSafe?TW.inSafe(i):true)){ st.caughtInSafe++; V('ghost'+i+' caught in safe n'+n+' k'+k+' pre=('+Math.round(pre[i].x)+','+Math.round(pre[i].y)+' '+pre[i].node+'>'+pre[i].to+') post=('+Math.round(g.x)+','+Math.round(g.y)+' '+g.node+') safeC=('+c.x+','+c.y+') guards='+G.guards.filter(h=>h.state!=='gone'&&Math.abs(h.y-g.y)<60&&Math.abs(h.x-g.x)<200).map(h=>h.kind+'/'+h.state+'@'+Math.round(h.x)+','+Math.round(h.y)).join(';')+' floats='+(G.floats||[]).slice(-3).map(f=>f.t).join('|')); } });
        act-=0.1; if (act>0) continue; act=1+R()*3;
        const live=G.gh.filter(g=>!g.home&&!g.out); if (!live.length) continue; const g=live[Math.floor(R()*live.length)]; G.active=g.i;
        const x=R(); if (x<0.25){ TW.goto(g.i,'f0_e'); } else if (x<0.8){ TW.goto(g.i,nodes[Math.floor(R()*nodes.length)].id); } else TW.act(); }
out.nights.push(st);
      if (!G.over){ G.dolls=6; TW.doll(); } TW.press('again'); }
    TW.pause(false); UNIT.manual=false; return out; },nights);
  console.log('RESULT '+JSON.stringify({lv,r,errs})); await b.close(); })();
