from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_page(viewport={'width':390,'height':844}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    print(J(pg,"""(()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();for(const k of ['toyol','xiaozhi']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);
      S.team=['afu','toyol','xiaozhi'].map(k=>S.ghosts.find(g=>g.k===k).id);Battle.start(0,0);
      const en=Battle.units.find(u=>u.side===1), f=Rework.fearOf(en.k);
      const types=k=>Rework.typesOf(k); const out={enemy:en.k,fear:f,toyol:types('toyol'),xiaozhi:types('xiaozhi'),afu:types('afu')};
      // 找兩隻嚇法都係敵人怕嘅鬼
      const mk=(k)=>({side:0,k,atk:100,x:100,lane:0,energy:0,hp:100,maxhp:100,st:{}});
      const weak=f.w; const cand=Object.keys(SCARE_GHOSTS).filter(k=>types(k)&&weak.includes(types(k)[0]));
      const a=cand.find(k=>types(k)[0]===weak[0]), b=cand.find(k=>types(k)[0]===weak[1]);
      out.a=a;out.b=b; const sk={name:'t',kind:'hit',mult:1};
      en.hp=1e6;en.maxhp=1e6; const n0=Battle.fx.length;
      const d1=Battle.hit(mk(a),en,1,sk), d2=Battle.hit(mk(b),en,1,sk);
      en.fearT=null; const d0=Battle.hit(mk('afu'),en,1,null);
      out.tags=Battle.fx.slice(n0).filter(x=>x.text&&/怕|連嚇|失神/.test(x.text)).map(x=>x.text); out.d=[d1,d2,d0];
      return JSON.stringify(out)})()"""))
    print(errs[:3]); b.close()
