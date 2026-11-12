// 鬼力關聯驗證：村入面 1/20/40 級 → 樓裡有鬼能力；見習；失敗返村升級
const { chromium } = require('playwright');
const OUT='/tmp/claude-0/out/'; const W=ms=>new Promise(r=>setTimeout(r,ms));
(async()=>{
  const b=await chromium.launch(); const ctx=await b.newContext({viewport:{width:390,height:844},isMobile:true,hasTouch:true,deviceScaleFactor:2});
  const pg=await ctx.newPage(); const errs=[]; const ev=(f,a)=>pg.evaluate(f,a);
  pg.on('pageerror',e=>errs.push('PE '+String(e).slice(0,300))); pg.on('console',m=>{ if(m.type()==='error') errs.push('CE '+m.text().slice(0,300)); });
  await pg.goto('http://127.0.0.1:8765/unit.html'); await pg.waitForFunction(()=>typeof S!=='undefined'&&typeof Tower!=='undefined'&&typeof GP!=='undefined',null,{timeout:60000}); await W(2500);
  await ev(()=>{ S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1; var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; var st0=document.createElement('style'); st0.textContent='#pol-tip,#pol-ov{display:none!important}'; document.head.appendChild(st0); window._hideSt=setInterval(function(){ var ss=document.getElementById('st-street'); if (ss&&ss.classList.contains('on')){ ss.classList.remove('on'); ss.style.display='none'; } },200); });
  const setLv=(k,lv)=>ev(([k,lv])=>{ const g=S.ghosts.find(g=>g.k===k); g.lv=lv; },[k,lv]);
  const R={};
  // ---- 1. 揀樓畫面（全部 1 級）
  await ev(()=>{ Tower.open(); }); await W(1200); await pg.screenshot({path:OUT+'gptw_title_lv1.png'});
  // ---- 2. 同一隻鬼（餓鬼王）1 / 20 / 40 級
  R.lv={};
  for (const lv of [1,20,40]){
    await setLv('eguiking',lv);
    const r=await ev(()=>{ TW.ng(12345,'flat'); TW.pause(true); const G=TW.G; G.guards.forEach(h=>{ h.wait=1e9; }); const g=G.gh[0]; G.active=0;
      const gp=TW.gp(); const o={pow:gp.gh[0].pow, mul:+gp.gh[0].mul.toFixed(3), team:gp.team, need:gp.need, F:+TW.gpF(0).toFixed(3)};
      // 嚇人量：同一個醒住、膽 0 嘅住客，嚇 38
      const r=G.res.find(r=>r.state==='home'); const bv=r.brave; r.brave=0; r.awake=true; r.fear=0; const rs=(r.unit.rs||[]); rs.forEach(q=>{ if(q!==r) q.state='x'; });
      g.energy=0; g._eL=0; TW.sr(r,38,0); o.scare=+r.fear.toFixed(2); r.fear=0; rs.forEach(q=>{ if(q.state==='x') q.state='home'; }); r.brave=bv;
      TW.step(0.016,1); o.energy=+g.energy.toFixed(2);           // 原始 +18 → ×em
      // 隱身
      g.invCd=0; TW.press('inv'); o.inv=+g.inv.toFixed(2); o.invCd=+g.invCd.toFixed(2);
      // 移動：由 f0_e 自動行去 f0 嘅樓梯口，量 1 秒行幾遠
      g.inv=0; g.invCd=0; const n0=G.nodes[g.node]; const tgt=n0.links.map(l=>G.nodes[l.to]).filter(m=>m.kind!=='in')[0]; TW.goto(0,tgt.id); const x0=g.x, y0=g.y; TW.step(0.05,6); o.speed=+Math.hypot(g.x-x0,g.y-y0).toFixed(1);
      o.tm=+gp.gh[0].tm.toFixed(3); o.um=+gp.gh[0].um.toFixed(3); return o; });
    // 入屋：入第一間入得嘅屋，撳作怪點，量住客驚值升幾多
    const u=await ev(()=>{ const G=TW.G, g=G.gh[0]; UNIT.manual=true; const u=G.units.find(u=>u.hh&&u.ot!=='deity'&&UNIT.canEnter(g,u)&&u.rs.some(r=>r.state==='home')); if (!u) return null; const d=G.nodes[u.did]; g.node=u.did; g.to=null; g.x=d.x; g.y=d.y; if (!UNIT.enterFromDoor(g,u)) return 'noenter'; return u.id; });
    if (u&&u!=='noenter'){ const h=await ev(()=>{ for (let k=0;k<12;k++) UNIT.step(0.1); const S0=UNIT._S(); S0.actors.forEach(a=>{ a.r.awake=true; a.r.brave=0; a.r.fear=0; }); let i=S0.spots.findIndex(p=>S0.actors.some(a=>a.room===undefined||true)); const before=S0.actors.map(a=>a.r.fear); let fired=-1; for (let j=0;j<S0.spots.length;j++){ if (UNIT.trig(j)){ fired=j; break; } } for (let k=0;k<3;k++) UNIT.step(0.1); return {spot:fired,k:fired>=0?S0.spots[fired].k:null, dfear:+S0.actors.reduce((s,a,ix)=>s+(a.r.fear-before[ix]),0).toFixed(2)}; }); r.unit=h; }
    else r.unit=u;
    if (lv===40){ await ev(()=>{ TW.pause(false); }); await W(600); await pg.screenshot({path:OUT+'gptw_hud_lv40.png'}); }
    R.lv[lv]=r; console.log('eguiking lv',lv,JSON.stringify(r));
  }
  await setLv('eguiking',1);
  // ---- 3. 未招募（攞走天花姐）＝見習
  await ev(()=>{ window._thBak=S.ghosts.filter(g=>g.k==='tianhua'); S.ghosts=S.ghosts.filter(g=>g.k!=='tianhua'); S._stnTest=1; });
  await ev(()=>{ TW.ng(777,'flat'); }); await W(300);
  R.trainee=await ev(()=>{ const gp=TW.gp(); return gp.gh.map(g=>[g.k,g.trainee,+g.mul.toFixed(2),g.pow]); });
  const b2=await ev(()=>TW.btns().find(b=>b.id==='gh2')); await pg.touchscreen.tap(b2.x+b2.w/2,b2.y+b2.h/2); await W(500);
  R.traineeToast=await ev(()=>TW.G.toast); await pg.screenshot({path:OUT+'gptw_trainee_hud.png'});
  console.log('trainee',JSON.stringify(R.trainee),R.traineeToast);
  await ev(()=>{ TW.press('quit'); }); await W(700); await pg.screenshot({path:OUT+'gptw_title_trainee.png'});
  // ---- 4. 失敗結算 → 返村升級
  await ev(()=>{ TW.ng(778,'flat'); TW.end('fail'); }); await W(700); await pg.screenshot({path:OUT+'gptw_fail.png'});
  const bv=await ev(()=>TW.btns().find(b=>b.id==='toVillage')); R.failBtn=!!bv; R.over=await ev(()=>{ const o=TW.G.over; return {why:o.why,gpTeam:o.gpTeam,gpNeed:o.gpNeed}; });
  if (bv){ await pg.touchscreen.tap(bv.x+bv.w/2,bv.y+bv.h/2); await W(1500); }
  R.after=await ev(()=>({towerOn:Tower.on, world:!!(document.getElementById('world')&&document.getElementById('world').innerHTML), sheet:document.getElementById('sheet').classList.contains('on'), sheetTitle:(document.querySelector('#sheet h2,#sheet .sh-title,#sheet header')||{}).textContent||'', hasRoster:!!document.querySelector('#sheet .gcard'), toast:[...document.querySelectorAll('#toasts .toast')].map(t=>t.textContent)}));
  await pg.screenshot({path:OUT+'gptw_village_roster.png'});
  console.log('fail',JSON.stringify(R.over),'btn',R.failBtn,'after',JSON.stringify(R.after));
  // ---- 5. 贏一晚 → 樓力 +1 → 建議鬼力升
  await ev(()=>{ S.ghosts=S.ghosts.concat(window._thBak); UI.close&&UI.close(); Tower.open(); });
  R.tier=await ev(()=>{ TW.ng(779,'flat'); const a=TW.gp(); TW.end('gate'); TW.ng(780,'flat'); const c=TW.gp(); return {before:[a.tier,a.need,+a.D.toFixed(3)], after:[c.tier,c.need,+c.D.toFixed(3)], win:S.tower.win_flat}; });
  console.log('tier',JSON.stringify(R.tier));
  await ev(()=>{ S.tower.win_flat=0; save(); });
  console.log('RESULT '+JSON.stringify(R)); console.log('ERRS '+JSON.stringify(errs)); await b.close();
})();
