import sys,json; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
O='/tmp/claude-0/out/'
def shot(pg,n): pg.screenshot(path=O+'gp_'+n+'.png'); print('  shot',O+'gp_'+n+'.png')
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1;S.seen.policy_tower=1;}")
    # ---- 1. 數值對比：同一隻鬼 1/20/40 級 ----
    r=pg.evaluate("""()=>{ const g=S.ghosts.find(x=>x.k==='laojiang'), o=g.lv, out=[]; const xs=Street.Turf; 
      for(const lv of [1,20,40]){ g.lv=lv; const u=Battle.mkGhostUnit(g,0); const sm={atk:(1+0.3*Math.pow(GP.mul(g),1.5))*1.15, cd:Math.pow(0.9,GP.mul(g))*0.89};
        out.push({lv, pow:GP.pow(g), mul:+GP.mul(g).toFixed(2), grow:+GP.grow(g).toFixed(2), battleAtk:Math.round(u.atk), battleHp:Math.round(u.hp), stationPower:Math.round(Station.power(g)), staffAtk:+sm.atk.toFixed(2), staffCd:+sm.cd.toFixed(2)}); }
      g.lv=o; return JSON.stringify(out); }""")
    print('數值', r)
    # ---- 2. 村入面名冊 ----
    pg.evaluate("()=>UI.openRoster()"); pg.wait_for_timeout(700)
    t=pg.evaluate("()=>document.querySelector('#sheet').innerText")
    print('roster has 鬼力:', '鬼力' in t, '升級後' in t, '所有玩法' in t); shot(pg,'roster')
    # 升級一次，鬼力要升
    a=pg.evaluate("()=>{const g=S.ghosts.find(x=>x.k==='xiaozhi'); const b=GP.pow(g); document.querySelector(`[data-up=\"${g.id}\"]`).click(); return [b,GP.pow(g),g.lv];}")
    print('升級前後鬼力', a)
    pg.evaluate("()=>UI.close()")
    # ---- 3. 主線選關：建議鬼力 ----
    pg.evaluate("()=>{ ['1-1','1-2','1-3','2-1','2-2','2-3','3-1','3-2','3-3','4-1','4-2'].forEach(k=>S.cleared[k]=true); Battle.openSelect(); }"); pg.wait_for_timeout(700)
    pg.evaluate("()=>{const e=[...document.querySelectorAll('.stg')].find(x=>x.textContent.includes('4-3')); e&&e.scrollIntoView({block:'center'});}"); pg.wait_for_timeout(300)
    print('select needs', pg.evaluate("()=>[...document.querySelectorAll('.stg .gp-need')].map(e=>e.className.split(' ').pop()+':'+e.textContent).join(' | ')"))
    shot(pg,'select')
    pg.evaluate("()=>UI.close()")
    # ---- 4. 主線打唔過 → 提示 → 返村升級 ----
    pg.evaluate("""()=>{ window.__lv=S.ghosts.map(g=>g.lv); S.ghosts.forEach(g=>{if(g.k!=='afu')g.lv=1}); Battle.start(5,2); Battle.speed=1; Battle.auto=true; let n=0; while(!Battle.result && n<30*100){ Battle.update(1/30); n++; } }""")
    pg.wait_for_timeout(800)
    print('lose box', pg.evaluate("()=>document.querySelector('#b-result').innerText.replace(/\\n+/g,' / ')"))
    shot(pg,'battle_lose')
    pg.evaluate("()=>document.querySelector('#b-result .gp-back').click()"); pg.wait_for_timeout(900)
    print('after 返村升級: sheet on', pg.evaluate("()=>document.querySelector('#sheet').classList.contains('on')"), 'title', pg.evaluate("()=>document.querySelector('#sheet .sh-h, #sheet h3, #sheet .sh-title') ? document.querySelector('#sheet .sh-h, #sheet h3, #sheet .sh-title').textContent : document.querySelector('#sheet').innerText.slice(0,10)"), 'battle on', pg.evaluate("()=>document.querySelector('#battle').classList.contains('on')"))
    shot(pg,'battle_back_roster')
    pg.evaluate("()=>{S.ghosts.forEach((g,i)=>g.lv=window.__lv[i]); UI.close();}")
    # 同一關：1 / 20 / 40 級主線戰鬥（自動，每級 3 場）
    r=pg.evaluate("""()=>{ const of=Battle.finish; let res=null; Battle.finish=function(w){res=w;this.result={win:w};this.active=false;}; const ss=Sound.play; Sound.play=()=>{};
      const keep=S.ghosts.map(g=>g.lv), out={}; for(const lv of [1,20,40]){ let w=0, hpLeft=0; for(let t=0;t<3;t++){ S.ghosts.forEach(g=>{if(g.k!=='afu')g.lv=lv}); res=null; Battle.start(3,2); Battle.auto=true; Battle.speed=1; let n=0; while(res===null&&n<30*120){Battle.update(1/30);n++;} if(res)w++; const foe=Battle.units.filter(u=>u.side===1); hpLeft+=foe.reduce((a,u)=>a+Math.max(0,u.hp),0)/foe.reduce((a,u)=>a+u.maxhp,0); }
        out[lv]={wins:w+'/3', foeHpLeft:Math.round(hpLeft/3*100)+'%', teamPow:GP.avg(S.team.map(ghostById))}; }
      S.ghosts.forEach((g,i)=>g.lv=keep[i]); Battle.finish=of; Sound.play=ss; Battle.active=false; document.getElementById('battle').classList.remove('on'); return JSON.stringify(out); }""")
    print('4-3 Pontianak 主線 1/20/40 級', r)
    # ---- 5. 陽間站崗地圖 ----
    pg.evaluate("()=>{ const s=Street.site('market'); s.lv=18; Street.open(); }"); pg.wait_for_timeout(1500)
    print('map', pg.evaluate("()=>[...document.querySelectorAll('.sts-plate[data-site]')].map(e=>e.innerText.replace(/\\n/g,' ')).join(' | ')"), '| top', pg.evaluate("()=>document.querySelector('.sts-gp').innerText"))
    shot(pg,'street_map')
    pg.evaluate("()=>Street.Turf.open('market')"); pg.wait_for_timeout(2500)
    # 起一部設備＋叫鬼加持（經真 UI）
    pg.evaluate("""()=>{ const T=Street.Turf, sd=T.sd; const i=T.lay.posts.findIndex(sp=>sp.h); sd.posts[i]={g:'dev:scare',role:'scare',sz:T.lay.posts[i].s||1,lv:2,build:0,spent:110,cd:0}; T.pickRole(i); window.__pi=i; }"""); pg.wait_for_timeout(700)
    print('staff btns', pg.evaluate("()=>[...document.querySelectorAll('#stt-pick [data-st]')].map(b=>b.innerText.replace(/\\n/g,' ')).join(' | ')"))
    shot(pg,'staff_pick')
    pg.evaluate("()=>{const b=[...document.querySelectorAll('#stt-pick [data-st]')].find(b=>b.textContent.includes('老殭')); b&&b.click();}"); pg.wait_for_timeout(500)
    pg.evaluate("()=>Street.Turf.pickRole(window.__pi)"); pg.wait_for_timeout(600)
    print('staff line', pg.evaluate("()=>[...document.querySelectorAll('#stt-pick p')].map(p=>p.innerText).filter(t=>t.includes('加持')).join(' / ')"))
    shot(pg,'staff_on')
    pg.evaluate("()=>{const e=document.getElementById('stt-pick'); e&&e.remove(); Street.Turf.specialPick();}"); pg.wait_for_timeout(700)
    print('boss list', pg.evaluate("()=>[...document.querySelectorAll('#stt-pick .stp-opt')].map(b=>b.innerText.replace(/\\n/g,' ')).join(' | ')"))
    shot(pg,'boss_pick')
    pg.evaluate("()=>{const e=document.getElementById('stt-pick'); e&&e.remove();}")
    # 有名鬼出招傷害 1/20/40
    print('boss dmg', pg.evaluate("""()=>{const g=S.ghosts.find(x=>x.k==='pontianak'),o=g.lv,r=[]; for(const lv of [1,5,17,20,40]){g.lv=lv; Street.Turf.specialPick(); const t=[...document.querySelectorAll('#stt-pick .stp-opt')].find(b=>b.textContent.includes(g.name)).querySelector('.gp-sub').innerText; r.push('Lv'+lv+' '+t); document.getElementById('stt-pick').remove();} g.lv=o; return r.join(' | ');}"""))
    # ---- 6. 打唔過：佔領度跌落 50% 以下 → 提示 → 返村升級 ----
    pg.evaluate("()=>{ const T=Street.Turf; T.sd.occH=[]; for(let i=0;i<30;i++) T.sd.occH.push(i%3?0:1); S.ghosts.forEach(g=>{}); T._gpT={}; T.hud(); }"); pg.wait_for_timeout(600)
    print('warn', pg.evaluate("()=>{const w=document.getElementById('gp-warn'); return w? w.innerText.replace(/\\n+/g,' / '):null}"))
    print('hud', pg.evaluate("()=>document.getElementById('stt-info').innerText.replace(/\\n/g,' ')"))
    shot(pg,'street_warn')
    pg.evaluate("()=>document.querySelector('#gp-warn .gp-back').click()"); pg.wait_for_timeout(1000)
    print('after 返村升級: turf on', pg.evaluate("()=>Street.Turf.on"), 'street on', pg.evaluate("()=>!!document.querySelector('#st-street.on')"), 'sheet', pg.evaluate("()=>document.querySelector('#sheet').classList.contains('on') && document.querySelector('#sheet').innerText.includes('用壽包升級鬼怪')"))
    shot(pg,'street_back_roster')
    # 封印 / 漏人跌級
    pg.evaluate("()=>{UI.close(); Street.open(); Street.Turf.open('market');}"); pg.wait_for_timeout(2000)
    print('seal warn', pg.evaluate("()=>{ const T=Street.Turf; T._gpT={}; T.bosses=[{g:S.ghosts.find(x=>x.k==='laojiang'),sealed:5}]; T.gpCheck(null); const w=document.getElementById('gp-warn'); return w? w.querySelector('b').innerText:null }"))
    print('drop warn', pg.evaluate("()=>{ const T=Street.Turf; T._gpT={}; T.bosses=[]; T.sd.lv=5; T.sd.maxLv=5; T.sd.hot=-999; T.leak({}); const w=document.getElementById('gp-warn'); return w? w.querySelector('b').innerText:null }"))
    # ---- 7. 夜班嚇人 / 運動會 ----
    print('scare gpq', pg.evaluate("()=>{const g=S.ghosts.find(x=>x.k==='toyol'),o=g.lv,r=[];for(const lv of [1,20,40]){g.lv=lv;r.push(lv+':'+Scare.gpq('toyol').toFixed(2));}g.lv=o;return r.join(' ')}"))
    print('errs', errs); b.close()
