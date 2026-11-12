// 量度保安行路速度（px/s，世界座標）：巡邏、查聲、追鬼
const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(()=>{
    TW.pause(true); const G=TW.G, DT=1/30;
    G.gh.forEach(g=>{ g.inv=1e9; });
    const out={};
    function meas(label,secs,filter){ const acc={}; const prev=new Map(); G.guards.forEach(h=>prev.set(h,{x:h.x,y:h.y}));
      let movD=0,movT=0,allD=0,allT=0;
      for (let i=0;i<secs*30;i++){ G.t=Math.min(G.t,30); TW.step(DT,1);
        G.guards.forEach(h=>{ const p=prev.get(h); if (!p){ prev.set(h,{x:h.x,y:h.y}); return; } if (!filter(h)) { prev.set(h,{x:h.x,y:h.y}); return; } const d=Math.hypot(h.x-p.x,(h.y-p.y)); if (d<50){ allD+=d; allT+=DT; if (d>0.01){ movD+=d; movT+=DT; } } prev.set(h,{x:h.x,y:h.y}); }); }
      out[label]={moving:+(movD/Math.max(1e-6,movT)).toFixed(1), overall:+(allD/Math.max(1e-6,allT)).toFixed(1), samples:Math.round(movT*30)}; }
    meas('patrol',40,h=>h.kind==='guard'&&h.state==='patrol');
    // 查聲：叫所有保安去同層一個遠啲嘅門
    G.guards.forEach(h=>{ if (h.kind!=='guard') return; const f=G.nodes[h.node].f; const ds=Object.values(G.nodes).filter(n=>n.f===f&&n.kind==='door').sort((a,b)=>Math.abs(b.x-h.x)-Math.abs(a.x-h.x)); if (ds[0]) TW.noise(ds[0].id,3); });
    meas('inv',6,h=>h.kind==='guard'&&h.state==='inv');
    // 追鬼：鬼企喺同層遠處（暈住所以唔會被捉），保安轉 chase
    const g=G.gh[0]; g.inv=0; g.stun=1e9; const h0=G.guards.find(h=>h.kind==='guard'); h0.state='chase'; h0.path=null; h0.to=null; h0.wait=0;
    const f0=G.nodes[h0.node].f; const far=Object.values(G.nodes).filter(n=>n.f===f0&&n.kind!=='in').sort((a,b)=>Math.abs(b.x-h0.x)-Math.abs(a.x-h0.x))[0]; g.node=far.id; g.to=null; g.x=far.x; g.y=far.y;
    G.guards.forEach(o=>{ if (o!==h0) o.wait=1e9; });
    meas('chase',4,h=>h===h0&&h.state==='chase');
    out.HUM=null; return out; });
  console.log(lv,JSON.stringify(r)); console.log('ERRS',errs); await b.close(); })();
