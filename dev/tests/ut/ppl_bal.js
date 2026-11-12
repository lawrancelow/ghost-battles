// 平衡＋安全區模擬：同一個腳本 AI（三隻鬼輪流：嚇人、行去有人嘅戶、俾人追就閃）跑幾晚，量捉鬼／追鬼節奏
// 用法：node ppl_bal.js <lv> <nights> <secs> [safe]   safe=1 時加測：鬼0 喺初始點進出、每 12 秒將一個保安擺去地庫追佢
const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat', nights=+(process.argv[3]||3), secs=+(process.argv[4]||180), SAFE=process.argv[5]==='1';
  const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(async([nights,secs,SAFE])=>{
    const out=[]; TW.pause(true);
    for (let n=0;n<nights;n++){
      if (n>0){ TW.press('again'); }
      const G=TW.G; const st={catches:0,outs:0,chaseStarts:0,chaseSec:0,spooks:0,fled:0,fear:0,alert:0,maxAlert:0,balks:0,balkTalk:0,viol:[],safeCatchTry:0,minGuardDist:1e9,guardsMax:0};
      const prevState=new Map(); let t=0, act=0, sw=0, lure=0;
      const S0=TW.safe?TW.safe():null;
      const caught0=G.gh.map(g=>g.caught);
      const resF=new Set();
      while (t<secs && !G.over){
        if (G.choice) TW.choose(0);
        // 一個 tick = 1/30 秒
        TW.step(1/30,1); if (window.UNIT&&UNIT.on()){ UNIT.manual=true; UNIT.step(1/30); } t+=1/30;
        G.guards.forEach(h=>{ const p=prevState.get(h); if (h.state==='chase'&&p!=='chase') st.chaseStarts++; if (h.state==='scared'&&p!=='scared') st.spooks++; if (h.state==='balk'&&p!=='balk'){ st.balks++; if (h.say) st.balkTalk++; } prevState.set(h,h.state); if (h.state==='chase') st.chaseSec+=1/30; });
        st.guardsMax=Math.max(st.guardsMax,G.guards.length);
        G.res.forEach(r=>{ if (r.state==='flee') resF.add(r); });
        st.maxAlert=Math.max(st.maxAlert,G.alert);
        // 安全區不變式
        if (S0&&TW.safe().on){ const SN=new Set(TW.safe().nodes);
          G.guards.forEach(h=>{ if (h.state==='gone') return; if (TW.inSafeXY(h.x,h.y)) st.viol.length<20&&st.viol.push('guard in zone '+h.kind+' '+h.state+' '+Math.round(h.x)+','+Math.round(h.y));
            if (SN.has(h.node)&&!(h.to&&!SN.has(h.to)&&h.p>0)) st.viol.length<20&&st.viol.push('guard node '+h.node+' '+h.state);
            if (h.to&&SN.has(h.to)) st.viol.length<20&&st.viol.push('guard heading '+h.to+' '+h.state);
            if (Math.abs(h.y-S0.y)<30) st.minGuardDist=Math.min(st.minGuardDist,Math.abs(h.x-S0.x)); });
          G.gh.forEach((g,i)=>{ if (g.caught>(g._pc==null?caught0[i]:g._pc)&&TW.inSafe(i)) st.viol.length<20&&st.viol.push('caught in zone gh'+i); g._pc=g.caught; }); }
        // ---- 腳本 AI（每 0.5 秒諗一次）----
        act-=1/30; if (act>0) continue; act=0.5;
        sw-=0.5; const alive=G.gh.filter(g=>!g.out&&!g.home); if (!alive.length) break;
        if (sw<=0||G.gh[G.active].out){ sw=6; const nx=alive[Math.floor(Math.random()*alive.length)]; G.active=nx.i; }
        if (SAFE){ // 鬼0：喺陰氣地同出面之間出入，引保安追
          const g0=G.gh[0]; lure-=0.5;
          if (lure<=0&&!g0.out){ lure=12; const hs=G.guards.filter(h=>h.kind==='guard'&&h.state==='patrol'); const h=hs[Math.floor(Math.random()*hs.length)];
            const outN=Object.values(G.nodes).filter(q=>q.f===0&&q.kind!=='in'&&!TW.safe().nodes.includes(q.id)&&Math.abs(q.x-S0.x)<520).sort((a,b)=>Math.abs(a.x-S0.x)-Math.abs(b.x-S0.x));
            if (h&&outN.length){ const far=outN[Math.min(outN.length-1,1+Math.floor(Math.random()*3))]; h.node=far.id; h.to=null; h.p=0; h.x=far.x; h.y=far.y; h.path=null; h.wait=0; h.state='chase'; h.zone=null;
              const near=outN[0]; g0.node=near.id; g0.to=null; g0.auto=null; g0.x=near.x; g0.y=near.y; g0.inv=0; g0.stun=0; TW.goto(0,'f0_e'); } }
          if (g0.node==='f0_e'&&!g0.to&&Math.random()<0.15){ const outN=Object.values(G.nodes).filter(q=>q.f===0&&q.kind==='door'&&!TW.safe().nodes.includes(q.id)).sort((a,b)=>Math.abs(a.x-S0.x)-Math.abs(b.x-S0.x)); if (outN[0]) TW.goto(0,outN[0].id); }
          if (G.active===0) G.active=alive.find(g=>g.i!==0)?alive.find(g=>g.i!==0).i:0; }
        const g=G.gh[G.active];
        if (window.UNIT&&UNIT.on()){ const U=UNIT.state(); g._inT=(g._inT||0)+0.5; if (!U||g._inT>14||!U.actors.some(a=>a.rstate==='home'&&a.st!=='run')){ UNIT.exit('door'); g._inT=0; } else if (Math.random()<0.6) UNIT.scare(); continue; }
        if (g.stun>0||g.inUnit) continue;
        // 俾人追：閃
        const thr=G.guards.find(h=>h.state!=='gone'&&h.state!=='flee'&&h.state!=='scared'&&!(h.kind==='decoy'&&!h.real)&&h.kind!=='collector'&&Math.abs(h.y-g.y)<40&&Math.abs(h.x-g.x)<(h.state==='chase'||h.kind!=='guard'?260:170)&&(h.state==='chase'||h.kind!=='guard'||(g.x-h.x)*h.dir>-20));
        if (thr){ const f=G.nodes[g.node].f; const cand=Object.values(G.nodes).filter(m=>m.f===f&&m.kind!=='in'&&m.kind!=='pipe'&&(m.x-thr.x)*(g.x-thr.x)>0).sort((a,b)=>Math.abs(b.x-thr.x)-Math.abs(a.x-thr.x)); for (const m of cand){ if (TW.goto(G.active,m.id)) break; } continue; }
        if (g.to||(g.auto&&g.auto.length)||g.autoS||g.sc) continue;
        if (g.scareCd<=0&&Math.random()<0.7){ TW.press('scare'); if (g.autoS||g.sc||g.scareCd>0) continue; }
        const hot=new Set(G.guards.filter(h=>h.state==='chase'||h.kind!=='guard').map(h=>G.nodes[h.node].f));
        const us=G.units.filter(u=>u.open&&u.ot!=='deity'&&!hot.has(u.f)&&u.rs.some(r=>r.state==='home'));
        if (us.length){ const u=us[Math.floor(Math.random()*us.length)]; TW.goto(G.active,u.did); }
      }
      st.catches=G.gh.reduce((a,g,i)=>a+g.caught-caught0[i],0); st.outs=G.gh.filter(g=>g.out).length; st.fled=resF.size; st.fear=G.fearTotal; st.alert=G.alert; st.t=Math.round(t); st.over=G.over?G.over.why:null;
      st.chaseSec=Math.round(st.chaseSec); st.uniqLines=TW.uq?TW.uq().length:null; if (st.minGuardDist===1e9) st.minGuardDist=null; else st.minGuardDist=Math.round(st.minGuardDist);
      out.push(st);
    }
    TW.pause(false); return out; },[nights,secs,SAFE]);
  const sum={}; r.forEach(s=>{ for (const k in s) if (typeof s[k]==='number') sum[k]=(sum[k]||0)+s[k]; });
  for (const k in sum) sum[k]=+(sum[k]/r.length).toFixed(2);
  r.forEach((s,i)=>console.log('night',i,JSON.stringify(s)));
  console.log('AVG',lv,JSON.stringify(sum)); console.log('VIOL',r.reduce((a,s)=>a+s.viol.length,0)); console.log('ERRS',errs); await b.close(); })();
