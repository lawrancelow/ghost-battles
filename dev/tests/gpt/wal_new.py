from playwright.sync_api import sync_playwright
import http.server, threading, functools
H=functools.partial(http.server.SimpleHTTPRequestHandler, directory='/tmp/claude-0/old')
class Q(http.server.SimpleHTTPRequestHandler):
    def log_message(self,*a): pass
srv=http.server.ThreadingHTTPServer(('127.0.0.1',8832),functools.partial(Q, directory='/tmp/claude-0/old')); threading.Thread(target=srv.serve_forever,daemon=True).start()
code=open('/tmp/claude-0/save_code.txt').read().strip()
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_context(viewport={'width':390,'height':844},is_mobile=True,has_touch=True).new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:300])); pg.on('console',lambda m: errs.append('c:'+m.text[:300]) if m.type=='error' else None)
    pg.goto('http://127.0.0.1:8832/new.html'); pg.wait_for_timeout(6000)
    pg.evaluate("(c)=>{var o=Web.dec(c); o.last=Date.now(); window.removeEventListener('beforeunload', save); localStorage.setItem(SAVE_KEY, JSON.stringify(o)); window.__NOSAVE=1;}", code)
    pg.reload(); pg.wait_for_timeout(6000)
    g0=pg.evaluate("()=>S.res.coins"); print('village coins start',g0)
    pg.evaluate("()=>{var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Street.open();}"); pg.wait_for_timeout(1500)
    print('map top', pg.evaluate("()=>document.querySelector('.sts-top span').textContent"))
    pg.evaluate("()=>{ Street.Turf.open('market'); }"); pg.wait_for_timeout(2500)
    print('wal', pg.evaluate("()=>Street.Turf.sd.wal"), 'village', pg.evaluate("()=>S.res.coins"))
    # 模擬嚇走/漏人
    pg.evaluate("()=>{ var T=Street.Turf; for(var i=0;i<20;i++){ var w={award:10,d:1,hist:[[0.5,0.5]],gone:null}; try{ T.sd.scared++; }catch(e){} } }")
    pg.evaluate("()=>{ var T=Street.Turf; T.sd.occH=[]; for(var i=0;i<30;i++) T.sd.occH.push(i%3?1:0); T.sd.wal+=0; T.hud(); }")
    print('hud coin', pg.evaluate("()=>document.getElementById('stt-coin').textContent"), '| info', pg.evaluate("()=>document.getElementById('stt-info').innerText"))
    pg.screenshot(path='/tmp/claude-0/out/wal_hud.png')
    # 真實起設備：開 pickRole 面板，撳第一個買得起嘅
    i=pg.evaluate("()=>{ var T=Street.Turf; var L=T.lay; for(var i=0;i<T.sd.posts.length+40;i++){ try{ if(!T.sd.posts[i]){ T.pickRole(i); if(document.querySelector('[data-r]')) return i; var x=document.querySelector('.stp'); if(x) x.remove(); } }catch(e){} } return -1; }")
    print('slot',i, 'btns', pg.evaluate("()=>[...document.querySelectorAll('[data-r]')].map(b=>b.dataset.r+':'+b.dataset.pr+':'+b.disabled).slice(0,4)"))
    pg.evaluate("()=>{ var b=[...document.querySelectorAll('[data-r]')].find(b=>!b.disabled); b&&b.click(); }"); pg.wait_for_timeout(500)
    print('after build wal', pg.evaluate("()=>Street.Turf.sd.wal"), 'village', pg.evaluate("()=>S.res.coins"), 'posts', pg.evaluate("()=>Street.Turf.sd.posts.filter(Boolean).length"))
    pg.evaluate("()=>Street.Turf.hud()"); print('info2', pg.evaluate("()=>document.getElementById('stt-info').innerText.slice(0,40)"))
    # 起設備花本關錢
    w1=pg.evaluate("()=>Street.Turf.sd.wal"); v1=pg.evaluate("()=>S.res.coins")
    # 真實流程：等路人自動進入一段時間
    pg.evaluate("()=>{ var T=Street.Turf; if(T.q){T.q.st='ready'; T.q.t=0.1;} }"); pg.wait_for_timeout(25000)
    print('after play wal', pg.evaluate("()=>Street.Turf.sd.wal"), 'village', pg.evaluate("()=>S.res.coins"), 'scared', pg.evaluate("()=>Street.Turf.sd.scared"), 'occH', pg.evaluate("()=>(Street.Turf.sd.occH||[]).length"))
    # 發展收入：倒撥 30 分鐘
    pg.evaluate("()=>{ var s=Street.st(); s.devT=Date.now()-30*60000; }")
    pg.evaluate("()=>{ Street.close(); Street.open(); }"); pg.wait_for_timeout(1500)
    pg.evaluate("()=>{ Street.close(); Street.open(); Street.Turf.open('market'); }"); pg.wait_for_timeout(2500); pg.evaluate("()=>{var t=document.getElementById('pol-tip'); if(t) t.remove();}")
    pg.screenshot(path='/tmp/claude-0/out/wal_hud2.png')
    pg.evaluate("()=>{ Street.close(); Street.open(); }"); pg.wait_for_timeout(800)
    print('village after 30min', pg.evaluate("()=>S.res.coins"), 'top', pg.evaluate("()=>document.querySelector('.sts-top span').textContent"))
    print('errs',errs); b.close()
srv.shutdown()
