// C：強制一個住客、一個保安被嚇；連續截圖；檢查 _scared 圖
const {boot,hookImgs}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat', tag=process.argv[3]||'new'; const {b,pg,errs}=await boot(lv); await hookImgs(pg);
  const O='/tmp/claude-0/out/qa_react_'+tag+'_';
  const info=await pg.evaluate(()=>{ const G=TW.G; TW.pause(true); G.gh.forEach(g=>{g.inv=1e9;});
    const r=G.res.find(q=>q.state==='home'&&q.unit&&q.unit.f>=2&&/^res_/.test(q.sprite||'')&&!q.brave)||G.res.find(q=>q.state==='home'&&q.unit&&q.unit.f>=1);
    const un=r.unit, g=G.gh[0]; G.active=0; g.inv=0; g.stun=0; g.scareCd=0; const n=G.nodes[un.id]; g.node=un.id; g.to=null; g.auto=null; g.x=n.x; g.y=n.y;
    G.guards.forEach(h=>{ h.wait=1e9; }); G.units.forEach(u=>{u.seen=true;}); window._R=r; TW.zoom(1.6); TW8.camTo(r.x,r.y-40); TW.step(0.05,1);
    return {sprite:r.sprite, hh:r.hh, f:un.f, x:r.x, unit:un.id, kind:n.kind}; });
  const shots=[]; const snap=async nm=>{ const p=O+nm+'.png'; await pg.screenshot({path:p}); shots.push(p); };
  const S=[]; const rec=async t=>S.push(await pg.evaluate((t)=>{ const r=window._R; return {t, state:r.state, fear:Math.round(r.fear), jumpT:r.jumpT, shockT:r.shockT, scream:r.scream&&r.scream.t, say:r.say, key:window.PPLFX?PPLFX.key(r.sprite,(r.shockT>0)||r.state==='flee'):null}; },t));
  await snap('res0_before'); await rec('before');
  let gotHit=0, gotFlee=0;
  for (let k=0;k<400&&gotFlee<2;k++){ const st=await pg.evaluate(()=>{ const G=TW.G,g=G.gh[0],r=window._R; if (r.state==='home'&&!g.sc&&g.scareCd<=0.05){ g.scareCd=0; g.stun=0; TW.press('scare'); } TW.step(0.05,1); TW8.camTo(r.x,r.y-40); TW.step(0.001,1); return {s:r.state,j:r.jumpT>0||r.shockT>0}; });
    if (st.j&&!gotHit){ gotHit=1; await snap('res1_hit'); await rec('hit'); await pg.evaluate(()=>{ TW.step(0.05,3); }); await snap('res2_shake'); await rec('shake'); }
    if (st.s==='flee'&&!gotFlee){ gotFlee=1; await snap('res3_flee'); await rec('flee0'); await pg.evaluate(()=>{ TW.step(0.05,10); const r=window._R; TW8.camTo(r.x,r.y-40); TW.step(0.001,1); }); await snap('res4_run'); await rec('flee1'); gotFlee=2; } }
  const resUse=await pg.evaluate(()=>({img:window._imgUse, pk:window._pkey||null}));
  // 保安
  const gi=await pg.evaluate(()=>{ const G=TW.G; window._imgUse={}; if (window._pkey) window._pkey={}; const h=G.guards.find(q=>q.kind==='guard'&&q.state==='patrol'); const g=G.gh[1]||G.gh[0]; G.active=g.i; g.inv=0; g.stun=0; g.scareCd=0; g.sc=null;
    const a=G.nodes[h.node]; h.wait=1e9; h.to=null; h.x=a.x; h.y=a.y; h.dir=1; g.node=h.node; g.to=null; g.auto=null; g.x=a.x-30; g.y=a.y; window._H=h; TW8.camTo(h.x,h.y-40); TW.step(0.02,1); return {kind:h.kind,node:h.node}; });
  const H=[]; const recH=async t=>H.push(await pg.evaluate((t)=>{ const h=window._H; return {t,state:h.state,shockT:h.shockT,say:h.say,scream:h.scream&&h.scream.t,x:Math.round(h.x)}; },t));
  await snap('grd0_before'); await pg.evaluate(()=>{ TW.press('scare'); TW.step(0.05,3); }); await recH('hit'); await snap('grd1_hit');
  await pg.evaluate(()=>{ TW.step(0.05,6); const h=window._H; TW8.camTo(h.x,h.y-40); TW.step(0.02,1); }); await recH('shake'); await snap('grd2_shake');
  const grdUse=await pg.evaluate(()=>({img:window._imgUse, pk:window._pkey||null}));
  const scaredRes=Object.keys(resUse.img).filter(k=>/_scared$/.test(k)), scaredGrd=Object.keys(grdUse.img).filter(k=>/_scared$/.test(k));
  console.log('RESULT '+JSON.stringify({lv,info,S,gi,H,scaredRes,scaredGrd,pkRes:resUse.pk,pkGrd:grdUse.pk,shots,errs})); await b.close(); })();
