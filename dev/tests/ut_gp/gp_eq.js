const {boot}=require('./common.js');
(async()=>{ const {b,pg,errs}=await boot('flat');
  const r=await pg.evaluate(()=>{ const out={}; const GPk=window.GP;
    for (const mode of ['noGP','mul1']){
      if (mode==='noGP') window.GP=undefined; else { window.GP=Object.assign({},GPk,{kindMul:()=>1,kindPow:()=>450}); }
      TW.ng(4242,'flat'); TW.pause(true); const G=TW.G, g=G.gh[0], gp=TW.gp();
      const r=G.res.find(r=>r.state==='home'); r.brave=0; r.awake=true; r.fear=0; (r.unit.rs||[]).forEach(q=>{ if(q!==r) q.state='x'; });
      g.energy=0; g._eL=0; TW.sr(r,38,0); const sc=r.fear; TW.step(0.016,1);
      g.invCd=0; TW.press('inv');
      out[mode]={has:gp.has,D:gp.D,F:TW.gpF(0),scare:sc,energy:g.energy,inv:g.inv,invCd:g.invCd,f:[gp.gh[0].spm,gp.gh[0].em,gp.gh[0].tm,gp.gh[0].im,gp.gh[0].icd,gp.gh[0].um]};
    } window.GP=GPk; TW.pause(false); return out; });
  console.log(JSON.stringify(r)); console.log('ERRS',JSON.stringify(errs)); await b.close(); })();
