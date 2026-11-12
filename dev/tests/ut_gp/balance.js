// 數值代理：同一個隨機代理人（sim.js 同款）、同一批種子，唔同鬼力／樓力配置，一晚嚇走幾多人、怕意幾多
const {boot}=require('/tmp/claude-0/ut/common.js');
(async()=>{ const lv=process.argv[2]||'flat', nights=+(process.argv[3]||3); const {b,pg,errs}=await boot(lv);
  const CF=[
    {n:'E 改之前（mul=1，冇樓力）',noGP:1,lv:{eguiking:1,toyol:1,tianhua:1},tier:0},
    {n:'A 新手：得餓鬼王1級＋兩隻見習',lv:{eguiking:1},drop:['toyol','tianhua'],tier:0},
    {n:'B 三隻1級，樓力0',lv:{eguiking:1,toyol:1,tianhua:1},tier:0},
    {n:'U 老闆存檔（餓鬼王17、Toyol17、天花姐見習）',lv:{eguiking:17,toyol:17},drop:['tianhua'],tier:0},
    {n:'C 三隻1級，樓力6',lv:{eguiking:1,toyol:1,tianhua:1},tier:6},
    {n:'D 三隻20級，樓力6',lv:{eguiking:20,toyol:20,tianhua:20},tier:6},
  ];
  const out=[];
  for (const cf of CF){
    const r=await pg.evaluate(([cf,lv,nights])=>{
      const keep=S.ghosts.slice(); const GPk=window.GP;
      S.ghosts=S.ghosts.filter(g=>!(cf.drop||[]).includes(g.k)); for (const k in cf.lv){ const g=S.ghosts.find(g=>g.k===k); if (g) g.lv=cf.lv[k]; }
      S.tower['win_'+lv]=cf.tier; if (cf.noGP) window.GP=undefined;
      let s=1; const R=()=>{ s=(s*16807)%2147483647; return (s-1)/2147483646; };
      const res={n:cf.n,fled:0,fear:0,flee1:0,gp:null}; UNIT.manual=true; TW.pause(true);
      for (let n=0;n<nights;n++){ TW.ng(1000+n,lv); const G=TW.G; if (!res.gp) res.gp=TW.gp(); let act=0; const f0=G.fearTotal; const seen=new Set();
        for (let k=0;k<2400;k++){ if (G.choice) TW.choose(0); if (G.over) break; TW.step(0.1,1); UNIT.step(0.1);
          G.res.forEach(r=>{ if ((r.state==='flee'||r.state==='gone')&&!seen.has(r)){ seen.add(r); } });
          const g=G.gh[G.active], S0=UNIT._S(); act-=0.1; if (act>0) continue; act=0.4+R()*0.8;
          if (!S0){ if (g.home||g.out){ const nx=G.gh.find(x=>!x.home&&!x.out); if (nx) G.active=nx.i; continue; }
            const cand=G.units.filter(u=>u.hh&&u.ot!=='deity'&&UNIT.canEnter(g,u)); if (!cand.length||R()<0.15) continue;
            const u=cand[Math.floor(R()*cand.length)]; const d=G.nodes[u.did]; g.node=u.did; g.to=null; g.auto=null; g.x=d.x; g.y=d.y; UNIT.enterFromDoor(g,u); continue; }
          const x=R();
          if (x<0.30){ UNIT.trig(Math.floor(R()*S0.spots.length)); } else if (x<0.55){ UNIT.scare(); }
          else if (x<0.75){ S0.goX=S0.lay.rooms[0].x0+R()*(S0.lay.rooms[S0.lay.rooms.length-1].x1-S0.lay.rooms[0].x0); }
          else if (x<0.82){ if (S0.task.k==='steal'&&!S0.task.done) S0.goX=S0.task.x; } else if (x<0.86){ UNIT.press('inv'); } else if (x<0.88){ UNIT.press('out'); } }
        res.fled+=seen.size; res.fear+=G.fearTotal-f0; if (UNIT._S()) UNIT.exit('door'); }
      // 解析：一個醒住、膽 0 嘅住客，用 38 點嚇（招式基本量）要幾多下先驚走
      const G=TW.G; res.hits=res.gp.gh.map((g,i)=>Math.ceil(100/(38*(g.mul/(res.gp.D||1))))); 
      S.ghosts=keep; window.GP=GPk; S.tower['win_'+lv]=0; TW.pause(false); UNIT.manual=false;
      res.gp={team:res.gp.team,need:res.gp.need,D:+res.gp.D.toFixed(2),mul:res.gp.gh.map(g=>+g.mul.toFixed(2))}; return res; },[cf,lv,nights]);
    out.push(r); console.log(JSON.stringify(r));
  }
  console.log('ERRS',JSON.stringify(errs)); await b.close(); })();
