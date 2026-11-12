// E2：入屋模式住客 Q 版圖＋驚嚇圖截圖
const {boot,hookImgs}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv); await hookImgs(pg);
  const W=ms=>pg.waitForTimeout(ms); const O='/tmp/claude-0/out/qa_unit_'+lv+'_';
  const u=await pg.evaluate(()=>{ const G=TW.G; G.t=5; G.guards.forEach(h=>{h.wait=1e9;}); const us=G.units.filter(u=>u.hh&&u.ot!=='deity'&&u.f>=1&&u.open&&!u.door&&u.rs.length>=1&&u.rs.every(r=>r.state==='home')&&u.rs.some(r=>/^res_/.test(r.sprite))); if (!us.length) us.push(...G.units.filter(u=>u.hh&&u.ot!=='deity'&&u.f>=1&&u.rs.length&&u.rs.some(r=>r.state==='home'&&/^res_/.test(r.sprite))).map(u=>{u.open=true;u.door=null;return u;}));
    const un=us[0]; const g=G.gh[G.active]; const d=G.nodes[un.did]; g.node=un.did; g.to=null; g.auto=null; g.x=d.x; g.y=d.y; const ok=UNIT.enterFromDoor(g,un); return {ok,id:un.id,hh:un.hh,spr:un.rs.map(r=>r.sprite)}; });
  await W(1500); await pg.evaluate(()=>{ window._pkey={}; }); await W(800);
  await pg.screenshot({path:O+'1_inside.png'}); const k1=await pg.evaluate(()=>window._pkey);
  await pg.evaluate(()=>{ window._pkey={}; });
  let sc=0; for (let i=0;i<6;i++){ const r=await pg.evaluate(()=>{ const s=UNIT.state(); if (!s) return null; const a=s.actors.find(a=>a.rstate==='home'&&a.st!=='run'); if (!a) return 'none'; UNIT.setAlert(Math.min(s.alert,30)); UNIT.setGX(a.x>700?a.x-90:a.x+90); UNIT.camSnap(); return UNIT.scare(); }); if (r===null||r==='none') break; if (r) sc++; await W(250); if (i===0){ await pg.screenshot({path:O+'2_scare.png'}); } await W(900); }
  await pg.screenshot({path:O+'3_after.png'}); const k2=await pg.evaluate(()=>({pk:window._pkey, st:UNIT.state()&&UNIT.state().actors.map(a=>a.rstate+'/'+a.st), on:UNIT.on()}));
  console.log('RESULT '+JSON.stringify({lv,u,inside:k1,scares:sc,after:k2,shots:[O+'1_inside.png',O+'2_scare.png',O+'3_after.png'],errs})); await b.close(); })();
