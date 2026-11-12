const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(()=>{ const G=TW.G; const f0=Object.values(G.nodes).filter(n=>n.f===0).sort((a,b)=>a.x-b.x).map(n=>n.id+':'+n.kind+':'+Math.round(n.x)+':'+n.links.map(l=>l.to).join('|'));
    const top=Object.values(G.nodes).filter(n=>n.kind==='portal').map(n=>n.id+':'+n.f+':'+Math.round(n.x));
    return {f0, top, y0:G.nodes['f0_e'].y, y1:G.nodes['f1_s'].y, guards:G.guards.map(h=>h.node), gh:G.gh.map(g=>g.node)}; });
  console.log(lv,JSON.stringify(r,null,0)); await b.close(); })();
