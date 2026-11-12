const {boot}=require('./common.js');
const OUT='/tmp/claude-0/out/';
const W=ms=>new Promise(r=>setTimeout(r,ms));
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv); const log=(...a)=>console.log(...a);
  const ev=(f,a)=>pg.evaluate(f,a);
  const tap=async(x,y)=>{ await pg.touchscreen.tap(x,y); await W(120); };
  const until=async(fn,arg,ms,step)=>{ const t0=Date.now(); while(Date.now()-t0<ms){ if (await ev(fn,arg)) return true; await W(step||150); } return false; };
  const res={}; const PFX=lv==='shop'?'unit_shop_':'unit_';
  await ev(()=>{ TW.G.t=5; });
  // ---- 揀一戶：有任務（偷嘢／全屋走晒）、開咗門、有人喺屋企
  const pickU=await ev(()=>{ const G=TW.G; const ok=['steal','allout']; const us=G.units.filter(u=>u.hh&&u.ot!=='deity'&&u.open&&!u.door&&u.f>=1&&u.rs.length&&u.rs.every(r=>r.state==='home')&&!u.ambush);
    const T={gamer:'media',ot:'steal',gym:'room',nurse:'room',elder:'media',insomnia:'media',granny:'steal',couple:'allout',mahjong:'steal',shopper:'steal',taxi:'media',cook:'room',helper:'steal',debt:'steal'};
    let u=us.find(u=>ok.indexOf(T[u.hh])>=0&&u.rs.length>=2)||us.find(u=>ok.indexOf(T[u.hh])>=0)||us[0]||G.units.find(u=>u.hh&&u.ot!=='deity'&&u.open&&u.f>=1&&u.rs.some(r=>r.state==='home')); return {id:u.id,did:u.did,f:u.f,hh:u.hh,x:u.x,y:u.y,n:u.rs.length}; });
  log('unit',JSON.stringify(pickU));
  // 測試設定：將鬼放喺該層樓梯口（之後全部真實點擊）
  await ev((U)=>{ const G=TW.G, g=G.gh[G.active]; const nb=G.nodes[U.did].links.map(l=>G.nodes[l.to]).filter(m=>m.kind!=='in'&&m.f===U.f).sort((a,b)=>Math.abs(a.x-U.x)-Math.abs(b.x-U.x))[0]; const sid=nb.id; const n=G.nodes[sid]; g.node=sid; g.to=null; g.auto=null; g.x=n.x; g.y=n.y; G.guards.forEach(h=>{ h.wait=1e9; h.state='patrol'; }); },pickU);
  await W(1500);
  // 1. 拖搖桿行去門口（真實拖動）
  for (let k=0;k<60;k++){ const g=await ev((U)=>{ const g=TW.G.gh[TW.G.active]; return {node:g.node,to:g.to,x:g.x,did:U.did,ux:U.x}; },pickU); if (g.node===g.did&&!g.to) break;
    const dir=g.ux>g.x?1:-1; await pg.mouse.move(195,520); await pg.mouse.down(); await pg.mouse.move(195+dir*20,520,{steps:2}); await pg.mouse.move(195+dir*50,520,{steps:2});
    for (let j=0;j<40;j++){ await W(60); const q=await ev((U)=>{ const g=TW.G.gh[TW.G.active]; return (g.node===U.did&&!g.to)||(g.to===U.did&&g.p>0.6)||(g.node===U.did&&g.to&&g.p<0.3)||Math.sign(U.x-g.x)!==Math.sign(U.x-g.x+0)&&false; },pickU); if (q) break; }
    await pg.mouse.up(); await W(500); }
  res.walk=await ev((U)=>{ const g=TW.G.gh[TW.G.active]; return g.node===U.did&&!g.to; },pickU);
  await W(700);
  res.btnShown=await ev((U)=>{ const un=TW.G.units.find(u=>u.id===U.id); return !!un._ib; },pickU);
  res.ctx=await ev(()=>{const a=TW.ctx(); return a&&{k:a.k,t:a.t};}); log('walk',res.walk,res.btnShown,JSON.stringify(res.ctx).slice(0,100), JSON.stringify(await ev(()=>{const g=TW.G.gh[TW.G.active]; return [g.node,g.to,Math.round(g.x),Math.round(g.y)];}))); await pg.screenshot({path:OUT+PFX+'1_door.png'});
  // 2. 撳門上「入屋」掣
  let p=await ev((U)=>{ const un=TW.G.units.find(u=>u.id===U.id), b=un._ib; return TW.w2s(b.x+b.w/2,b.y+b.h/2); },pickU); await tap(p.x,p.y);
  res.entered=await until(()=>UNIT.on(),null,3000); await W(900);
  await pg.screenshot({path:OUT+PFX+'2_inside.png'});
  let st=await ev(()=>UNIT.state()); log('inside',JSON.stringify(st).slice(0,600));
  // 3. 拖動搖桿向右
  const gx0=st.gx; await pg.mouse.move(150,420); await pg.mouse.down(); await pg.mouse.move(175,420,{steps:3}); await pg.mouse.move(215,420,{steps:4}); await W(900); await pg.mouse.up(); await W(300);
  st=await ev(()=>UNIT.state()); res.joyMoved=st.gx-gx0; 
  // 4. 撳作怪點（揀有醒住住客嘅房）
  const sp=await ev(()=>{ const s=UNIT.state(); const rooms=s.actors.filter(a=>a.awake).map(a=>a.room); let i=s.spots.findIndex(p=>rooms.indexOf(p.room)>=0); if (i<0) i=0; return {i,room:s.spots[i].room,k:s.spots[i].k,x:s.spots[i].x,y:s.spots[i].y}; });
  const fear0=await ev(()=>UNIT.state().actors.map(a=>a.fear));
  await ev((sp)=>{ UNIT.setGX(sp.x-60); UNIT.camSnap(); },sp); await W(300);
  p=await ev((sp)=>UNIT.toScreen(sp.x,sp.y),sp); await tap(p.x,p.y);
  res.hot=await until((i)=>UNIT.state().spots[i].cd>0,sp.i,8000); await W(500);
  await pg.screenshot({path:OUT+PFX+'3_hotspot.png'});
  const fear1=await ev(()=>UNIT.state().actors.map(a=>a.fear)); res.hotFear=[fear0,fear1,sp.k];
  // 5. 直接嚇人：撳住客，直到驚走
  const ft0=await ev(()=>TW.G.fearTotal);
  const nres=pickU.n; let fled=0;
  for (let k=0;k<40;k++){ const a=await ev(()=>{ const s=UNIT.state(); if (!s) return null; const a=s.actors.find(a=>a.rstate==='home'&&a.st!=='run'); return a?{x:a.x,act:a.act}:null; }); if (!a) break;
    await ev((a)=>{ UNIT.setAlert(Math.min(UNIT.state().alert,40)); },a);   // 測試：控制警覺，專注測驚走
    const q=await ev((a)=>{ const s=UNIT.state(); if (Math.abs(s.gx-a.x)>160) UNIT.setGX(a.x>700?a.x-120:a.x+120); UNIT.camSnap(); return UNIT.toScreen(a.x,(s.lay==='gamer'?820:770)-120); },a); await tap(q.x,q.y);
    if (k===1) { await W(700); await pg.screenshot({path:OUT+PFX+'4_scare.png'}); }
    await W(2300); }
  await W(1500);
  res.fled=await ev((U)=>TW.G.units.find(u=>u.id===U.id).rs.map(r=>r.state),pickU);
  res.fearGain=(await ev(()=>TW.G.fearTotal))-ft0;
  // 6. 任務（偷嘢：撳任務點，企定讀條）
  res.onBeforeTask=await ev(()=>UNIT.on()); if (!res.onBeforeTask) await ev((U)=>{ const G=TW.G, g=G.gh[G.active], un=G.units.find(u=>u.id===U.id); un.iu.cd=0; un.iu.ban=0; UNIT.enterFromDoor(g,un); },pickU); await W(500);
  st=await ev(()=>UNIT.state()); res.taskK=st.task.k;
  if (st.task.k==='steal'&&!st.task.done){ await ev((x)=>{ UNIT.setGX(x+200>1400?x-200:x+200); UNIT.camSnap(); },st.task.x); await W(200);
    p=await ev(()=>{ const s=UNIT.state(); return UNIT.toScreen(s.task.x,(s.lay==='gamer'?820:770)-5); }); await tap(p.x,p.y); await until(()=>UNIT.state().task.done,null,9000); }
  st=await ev(()=>UNIT.state()); res.taskDone=st.task.done; await W(600); await pg.screenshot({path:OUT+PFX+'5_task.png'});
  res.reward=await ev(()=>({tasks:TW.G.unitTasks,coins:TW.G.unitCoins,dolls:TW.G.dolls}));
  // 7. 撳「出屋」
  const ob=await ev(()=>UNIT.btns().find(b=>b.id==='out')); await tap(ob.x+ob.w/2,ob.y+ob.h/2); await W(800);
  res.out=await ev((U)=>{ const g=TW.G.gh[TW.G.active], un=TW.G.units.find(u=>u.id===U.id); return {on:UNIT.on(), inUnit:!!g.inUnit, node:g.node, did:U.did, done:un.iu.done, story:TW.G.story.slice(), res:un.rs.map(r=>r.state)}; },pickU);
  await W(600); await pg.screenshot({path:OUT+PFX+'6_back.png'});
  // 再入一次：任務唔會重複獎
  await ev((U)=>{ const G=TW.G, g=G.gh[G.active], un=G.units.find(u=>u.id===U.id); un.iu.cd=0; UNIT.enterFromDoor(g,un); },pickU); await W(600);
  res.reenter=await ev(()=>({on:UNIT.on(),done:UNIT.state()&&UNIT.state().task.done,tasks:TW.G.unitTasks,coins:TW.G.unitCoins})); await ev(()=>UNIT.exit('door')); await W(300);
  // 8. 神明鎮宅戶：撳門
  const dU=await ev(()=>{ const u=TW.G.units.find(u=>u.ot==='deity'&&u.f>=1); return u?{id:u.id,did:u.did,f:u.f,x:u.x,y:u.y}:null; });
  if (dU){ await ev((U)=>{ const G=TW.G, g=G.gh[G.active]; const n=G.nodes[U.did]; g.node=U.did; g.to=null; g.auto=null; g.x=n.x; g.y=n.y; G.floats=[]; G.fcd={}; },dU); await W(1200);
    res.deityCtx=await ev(()=>{const a=TW.ctx(); return a&&{k:a.k,t:a.t};});
    p=await ev((U)=>TW.w2s(U.x,U.y-40),dU); await tap(p.x,p.y); await W(400);
    res.deity=await ev(()=>({on:UNIT.on(), floats:TW.G.floats.map(f=>f.t)})); await pg.screenshot({path:OUT+PFX+'7_deity.png'}); }
  // 9. 警覺爆：入另一戶，企喺燈著嘅房俾人見到
  const kU=await ev((id)=>{ const G=TW.G; const u=G.units.filter(u=>u.id!==id&&u.f>=2&&!G.cprops.some(c=>c.node===u.did)&&u.hh&&u.ot!=='deity'&&u.open&&!u.door&&u.rs.some(r=>r.state==='home'&&r.awake))[0]; return u?{id:u.id,did:u.did,f:u.f,x:u.x,y:u.y}:null; },pickU.id);
  if (kU){ await ev((U)=>{ const G=TW.G, g=G.gh[G.active]; const n=G.nodes[U.did]; g.node=U.did; g.to=null; g.auto=null; g.x=n.x; g.y=n.y; },kU); await W(1500);
    const kc=await ev(()=>{const a=TW.ctx(); return a&&{k:a.k,t:a.t};}); res.kCtx=kc;
    if (kc&&kc.k==='unitIn'){ const ab=await ev(()=>TW.btns().find(b=>b.id==='act')); await tap(ab.x+ab.w/2,ab.y+ab.h/2); }
    else { p=await ev((U)=>{ const un=TW.G.units.find(u=>u.id===U.id), b=un._ib; return b?TW.w2s(b.x+b.w/2,b.y+b.h/2):TW.w2s(U.x,U.y-40); },kU); await tap(p.x,p.y); }
    res.kEnter=await until(()=>UNIT.on(),null,3000);
    const a0=await ev(()=>{ const s=UNIT.state(); if (!s) return null; const a=s.actors.find(a=>a.awake&&a.act!=='bed'); return a; });
    await ev((a)=>{ UNIT.setAlert(80); },a0);
    const ga=await ev(()=>TW.G.alert);
    for (let k=0;k<30;k++){ if (!(await ev(()=>UNIT.on()))) break; const a=await ev(()=>{ const s=UNIT.state(); return s&&s.actors.find(a=>a.awake&&a.st!=='run'); }); if (!a) break;
      await ev((a)=>{ UNIT.setGX(a.x+40); UNIT.camSnap(); },a); 
      if (k===3) await pg.screenshot({path:OUT+PFX+'8_seen.png'});
      await W(400); }
    res.kick=await ev((U)=>{ const G=TW.G, un=G.units.find(u=>u.id===U.id), g=G.gh[G.active]; return {on:UNIT.on(), ban:Math.round(un.iu.ban), node:g.node, did:U.did, alert:G.alert}; },kU); res.kick.alert0=ga;
    await W(600); await pg.screenshot({path:OUT+PFX+'9_kicked.png'});
    p=await ev((U)=>TW.w2s(U.x,U.y-40),kU); await tap(p.x,p.y); await W(400); res.reban=await ev(()=>({on:UNIT.on(), f:TW.G.floats.map(f=>f.t).filter(t=>t.indexOf('秒')>=0)})); }
  res.err=await ev(()=>UNIT._err||null);
  log(JSON.stringify(res,null,1)); log('ERRS',errs); await b.close(); })();
