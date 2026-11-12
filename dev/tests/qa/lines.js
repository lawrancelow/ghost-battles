// D：一晚入面所有慘叫（scream）唔可以兩個唔同人講同一句
const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(()=>{ let s=11; const R=()=>{ s=(s*16807)%2147483647; return (s-1)/2147483646; };
    UNIT.manual=true; TW.pause(true); const G=TW.G; const ID=new WeakMap(); let nid=0; const id=o=>{ if (!ID.has(o)) ID.set(o,++nid); return ID.get(o); };
    const scream={}, fleeSay={}, sayAll={}; const add=(M,t,o)=>{ if (!t) return; (M[t]=M[t]||new Set()).add(id(o)); };
    let act=0, fled=0; const seenFlee=new Set();
    for (let k=0;k<2400;k++){ if (G.choice) TW.choose(0); if (G.over) break; G.gh.forEach(g=>{ if (g.caught>=2) g.caught=0; });
      TW.step(0.1,1); if (UNIT._S&&UNIT._S()) UNIT.exit('door');
      G.res.concat(G.guards).forEach(o=>{ if (o.scream&&o.scream.t) add(scream,o.scream.t,o); if (o.state==='flee'){ if (!seenFlee.has(o)){ seenFlee.add(o); fled++; } add(fleeSay,o.say,o); } add(sayAll,o.say,o); });
      G.alert=0; act-=0.1; if (act>0) continue; act=0.3;
      const g=G.gh.find(q=>!q.home&&!q.out); if (!g) continue; G.active=g.i; g.stun=0; g.inv=0;
      if (!window._T||window._T.state!=='home'||window._TT>8){ const useG=R()<0.25; window._TT=0;
        if (useG){ const hs=G.guards.filter(h=>h.state==='patrol'||h.state==='chase'); if (hs.length){ const h=hs[Math.floor(R()*hs.length)]; const a=G.nodes[h.node]; g.node=h.node; g.to=null; g.auto=null; g.sc=null; g.x=h.x-(h.dir||1)*30; g.y=a.y; g.scareCd=0; TW.press('scare'); } window._T=null; continue; }
        const rs=G.res.filter(q=>q.state==='home'&&q.unit); if (!rs.length) continue; window._T=rs[Math.floor(R()*rs.length)]; const n=G.nodes[window._T.unit.id]; g.node=window._T.unit.id; g.to=null; g.auto=null; g.sc=null; g.x=n.x; g.y=n.y; }
      window._TT+=0.3; if (!g.sc&&g.scareCd<=0) TW.press('scare'); }
    const dup=M=>Object.entries(M).filter(([t,S])=>S.size>1).map(([t,S])=>t+' ×'+S.size);
    TW.pause(false); UNIT.manual=false;
    return {t:Math.round(G.t), fled, nScream:Object.keys(scream).length, screamDup:dup(scream), fleeSayDup:dup(fleeSay), sayDupInfo:dup(sayAll).slice(0,15), sample:Object.keys(scream).slice(0,8)}; });
  console.log('RESULT '+JSON.stringify({lv,r,errs})); await b.close(); })();
