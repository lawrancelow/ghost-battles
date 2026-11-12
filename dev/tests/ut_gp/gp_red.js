const {boot}=require('./common.js');
(async()=>{ const {b,pg,errs}=await boot('flat'); await pg.setViewportSize({width:390,height:844});
  const r=await pg.evaluate(()=>{ window._k=S.ghosts.filter(g=>g.k==='toyol'||g.k==='tianhua'); S.ghosts=S.ghosts.filter(g=>g.k!=='toyol'&&g.k!=='tianhua'); S.tower.win_flat=3; TW.ng(55,'flat'); const a=TW.gp(); TW.end('fail'); return {team:a.team,need:a.need,D:a.D}; });
  await pg.waitForTimeout(700); await pg.screenshot({path:'/tmp/claude-0/out/gptw_fail_red.png'});
  await pg.evaluate(()=>{ TW.press('quit'); }); await pg.waitForTimeout(600); await pg.screenshot({path:'/tmp/claude-0/out/gptw_title_red.png'});
  await pg.evaluate(()=>{ S.ghosts=S.ghosts.concat(window._k); S.tower.win_flat=0; save(); });
  console.log(JSON.stringify(r),'ERRS',JSON.stringify(errs)); await b.close(); })();
