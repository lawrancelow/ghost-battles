// A：每種保安巡邏／追捕實際位移 px/s（世界座標）
const {boot}=require('./common.js');
(async()=>{ const lv=process.argv[2]||'flat'; const {b,pg,errs}=await boot(lv);
  const r=await pg.evaluate(()=>{
    TW.pause(true); const G=TW.G, DT=1/30, all=G.guards.slice(), out={};
    const flN=f=>Object.values(G.nodes).filter(n=>n.f===f&&n.kind!=='in'&&n.kind!=='portal').sort((a,b)=>a.x-b.x);
    function place(o,n){ o.node=n.id; o.to=null; o.p=0; o.x=n.x; o.y=n.y; o.path=null; o.auto=null; }
    function meas(h,secs,filt){ let px=h.x,py=h.y,movD=0,movT=0,allD=0,allT=0;
      for (let i=0;i<secs*30;i++){ G.t=Math.min(G.t,30); TW.step(DT,1); const d=Math.hypot(h.x-px,h.y-py); if (filt(h)&&d<50){ allD+=d; allT+=DT; if (d>0.01){ movD+=d; movT+=DT; } } px=h.x; py=h.y; }
      return {moving:+(movD/Math.max(1e-6,movT)).toFixed(1), overall:+(allD/Math.max(1e-6,allT)).toFixed(1), n:Math.round(movT*30)}; }
    const KS=['guard','compass','mirror','decoy','dog'];
    for (const k of KS){ const h=all[0]; G.guards=[h]; Object.assign(h,{kind:k,state:'patrol',wait:0,real:true,courage:99,boost:1,catchCd:0,lostT:0,balkCd:0,shockT:0,zone:null});
      G.gh.forEach(g=>{ g.inv=1e9; g.stun=0; }); const F=flN(3); place(h,F[Math.floor(F.length/2)]);
      const pat=meas(h,30,o=>o.state==='patrol');
      // 追捕：鬼同保安同層兩頭，鬼暈住（唔會被捉）
      const g=G.gh[0]; G.gh.forEach((o,i)=>{ if (i) o.inv=1e9; }); g.inv=0; g.stun=1e9; g.home=false; g.out=false;
      place(h,F[0]); place(g,F[F.length-1]); Object.assign(h,{state:'chase',wait:0,path:null,repath:0,alertT:0,lostT:0,balkCd:0});
      const ch=meas(h,3,o=>o.state==='chase');
      out[k]={patrol:pat,chase:ch}; }
    G.guards=all; return out; });
  console.log('RESULT '+JSON.stringify({lv,r,errs})); await b.close(); })();
