const {boot}=require('./common.js');
(async()=>{ const {b,pg,errs}=await boot(process.argv[2]||'flat');
  const r=await pg.evaluate(()=>{ const G=TW.G; const g=G.gh[G.active]; const us=G.units.filter(u=>u.hh&&u.ot!=='deity'&&u.open&&u.rs.some(r=>r.state==='home'));
    const un=us[0]; g.node=un.did; const n=G.nodes[un.did]; g.x=n.x; g.y=n.y; g.to=null; g.auto=null;
    const ok=UNIT.enterFromDoor(g,un); return {ok, hh:un.hh, n:us.length, st:UNIT.state()}; });
  console.log(JSON.stringify(r).slice(0,1500));
  await pg.waitForTimeout(1500); await pg.screenshot({path:'/tmp/claude-0/out/unit_smoke_'+(process.argv[2]||'flat')+'.png'});
  console.log(errs); await b.close(); })();
