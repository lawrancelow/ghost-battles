from playwright.sync_api import sync_playwright
import os
f='file:///home/claude/gb/GhostBattles.html'
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome')
    ctx=b.new_context(viewport={'width':390,'height':844},device_scale_factor=1)
    pg=ctx.new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.on('console',lambda m: errs.append('console:'+m.text) if m.type=='error' else None)
    pg.goto(f+'?debug&nophone');pg.wait_for_function('window.G');pg.wait_for_timeout(500)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.lv=8;S.bld.house=3;S.bld.plank=1;S.bld.bun=1;S.bld.furnace=1;S.furnaceAt=0;S.res.wood=20;S.res.rice=12;S.posts&&0;save();}")
    pg.evaluate("()=>{const S=G.S();for(const g of S.ghosts)g.post=null;}")
    def st(): return pg.evaluate("(()=>{const S=G.S();return {wood:S.res.wood,planks:S.res.planks,rice:S.res.rice,buns:S.res.buns,cp:S.cnt.craftPlank,cb:S.cnt.craftBun,exp:S.exp}})()")
    def run_until_idle(t=15000):
        pg.wait_for_timeout(300)
        pg.wait_for_function("(()=>{const H=G.Village.hero;return !H.act&&!H.target})()",timeout=t)
    # sheet screenshot
    pg.evaluate("G.UI.openBuilding('plank')"); pg.wait_for_timeout(500)
    pg.evaluate("document.querySelector('#sheet .craft-row').scrollIntoView({block:'center'})"); pg.wait_for_timeout(200)
    pg.screenshot(path='/tmp/claude-0/craft_btns.png')
    labels=pg.evaluate("[...document.querySelectorAll('#sheet [data-act=craft]')].map(b=>b.textContent+(b.disabled?'(禁用)':''))")
    print('buttons',labels)
    # batch 5 planks
    s0=st(); durs=[]
    pg.click("#sheet [data-act=craft][data-n='5']")
    pg.wait_for_function("G.Village.hero.act&&G.Village.hero.act.kind==='craft'",timeout=10000)
    durs=pg.evaluate("""new Promise(r=>{const ds=[];const iv=setInterval(()=>{const a=G.Village.hero.act;if(a&&a.kind==='craft'){if(ds[ds.length-1]!==a.done+':'+a.dur)ds.push(a.done+':'+a.dur)}else{clearInterval(iv);r(ds)}},30)})""")
    run_until_idle(); s1=st()
    print('batch5', s0,'->',s1,'durs',durs)
    assert s1['planks']-s0['planks']==10 and s0['wood']-s1['wood']==20 and s1['cp']-s0['cp']==5
    # batch 10 buns with rice=12 -> 3
    floats=[]
    pg.evaluate("()=>{window.__fl=[];setInterval(()=>{for(const f of G.Village.floats)if(!__fl.includes(f.text))__fl.push(f.text)},20)}")
    pg.evaluate("()=>{G.Village.floats.length=0}")
    pg.evaluate("G.UI.openBuilding('bun')"); pg.wait_for_timeout(300)
    s0=st(); pg.click("#sheet [data-act=craft][data-n='10']")
    pg.wait_for_function("G.Village.hero.act&&G.Village.hero.act.kind==='craft'",timeout=10000)
    run_until_idle(); s1=st(); pg.wait_for_timeout(100)
    fl=pg.evaluate("window.__fl")
    print('batch10/short', s0,'->',s1,'floats',fl)
    assert s1['buns']-s0['buns']==6 and s0['rice']-s1['rice']==12 and s1['cb']-s0['cb']==3 and any('材料只夠做 3 份' in x for x in fl)
    # single
    pg.evaluate("()=>{G.S().res.wood=4}"); pg.evaluate("G.UI.openBuilding('plank')"); pg.wait_for_timeout(300)
    s0=st(); pg.click("#sheet [data-act=craft][data-n='1']"); pg.wait_for_function("G.Village.hero.act",timeout=10000); run_until_idle(); s1=st()
    print('single',s0,'->',s1); assert s1['planks']-s0['planks']==2 and s1['cp']-s0['cp']==1
    pg.evaluate("G.UI.openBuilding('plank')"); pg.wait_for_timeout(300)
    print('disabled when empty', pg.evaluate("[...document.querySelectorAll('#sheet [data-act=craft]')].every(b=>b.disabled)"))
    # furnace
    pg.evaluate("G.UI.close()"); pg.evaluate("()=>{G.S().furnaceAt=0}")
    pg.evaluate("G.UI.openBuilding('furnace')"); pg.wait_for_timeout(400)
    c0=pg.evaluate("G.S().res.coins")
    pg.click("#sheet [data-act=burn]")
    pg.wait_for_timeout(1100)
    print('fx canvas present', pg.evaluate("!!document.querySelector('#jossfx')"), pg.evaluate("(()=>{const c=document.querySelector('#jossfx');return c&&[c.width,c.height,getComputedStyle(c).zIndex,getComputedStyle(c).pointerEvents]})()"))
    pg.screenshot(path='/tmp/claude-0/furnace_fx.png')
    pg.wait_for_timeout(2300)
    print('fx removed', pg.evaluate("!document.querySelector('#jossfx')"), 'coins +', pg.evaluate("G.S().res.coins")-c0)
    # not ready -> no effect
    pg.evaluate("G.UI.openBuilding('furnace')"); pg.wait_for_timeout(300)
    print('burn disabled when not ready', pg.evaluate("document.querySelector('#sheet [data-act=burn]').disabled"))
    pg.evaluate("G.JossFx&&0")
    print('errs',errs)
    b.close()
