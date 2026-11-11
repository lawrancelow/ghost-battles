# 由 /home/claude/lyg（樓裡有鬼獨立版）生成 gb/src/tower.js + tower_assets.js
import base64, json, re
L='/home/claude/lyg'; D='/home/claude/gb/src/'
s=open(L+'/src/pangsa.js',encoding='utf-8').read()
def R(a,b,cnt=1):
    global s
    assert s.count(a)==cnt,(a[:70],s.count(a)); s=s.replace(a,b)
R("(function(){\n","const Tower=(function(){\n  var OPEN=false, RAF=0, ROOT=document.createElement('section'); ROOT.id='tw-root'; ROOT.className='tw-root';\n  var _cv=document.createElement('canvas'); _cv.className='tw-cv'; ROOT.appendChild(_cv); document.body.appendChild(ROOT);\n  function TS(){ if (!S.tower) S.tower={unlocked:true,cleared:{},best:0,nights:0}; S.tower.cleared=S.tower.cleared||{}; return S.tower; }\n  if (typeof World!=='undefined') World.ICON.tower='樓';\n")
R("var cv=document.getElementById('c'), ctx=cv.getContext('2d');","var cv=_cv, ctx=cv.getContext('2d');")
R("try{ var sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); sv.nights=(sv.nights||0)+1; if (why!=='fail'){ sv.best=Math.max(sv.best||0,kept); sv['clear_'+curLv]=1; } localStorage.setItem('lyg_pangsa',JSON.stringify(sv)); }catch(e){}",
  "try{ var sv=TS(), first=why==='gate'&&!sv['gate_'+curLv]; if (first) sv['gate_'+curLv]=1; sv.nights=(sv.nights||0)+1; var rw=why==='gate'?40+15*kept+25*story:why==='doll'?20+8*kept:0; if (first) rw+=100; if (why!=='fail'){ sv.best=Math.max(sv.best||0,kept); sv.cleared[curLv]=1; } G.over.reward=rw; S.res.coins+=rw; save(); }catch(e){ console.error(e); }")
R("var sv={}; try{ sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); }catch(e){} var shopOpen=!!sv.clear_flat||Q.has('unlock');",
  "var sv=TS(); var shopOpen=!!sv.cleared.flat||Q.has('unlock')||!!window.STN_TEST;")
R("'組屋'+(sv.clear_flat?' ✓':'')","'組屋'+(sv.cleared.flat?' ✓':'')"); R("'老店屋'+(sv.clear_shop?' ✓':'')","'老店屋'+(sv.cleared.shop?' ✓':'')")
R("if (id==='lv_shop'){ var sv={}; try{ sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); }catch(e){} if (sv.clear_flat||Q.has('unlock')){",
  "if (id==='exit'){ close(); return; }\n    if (id==='quit'){ scene='title'; return; }\n    if (id==='lv_shop'){ var sv=TS(); if (sv.cleared.flat||Q.has('unlock')||window.STN_TEST){")
R("if (id==='title'){ scene='title'; return; }","if (id==='title'){ scene='title'; return; } if (id==='toMap'){ close(); return; }")
# 返地圖掣
R("  function drawTitle(){ ctx.fillStyle='#0e0e11'; ctx.fillRect(0,0,VW,VH);","  function drawTitle(){ ctx.fillStyle='#0e0e11'; ctx.fillRect(0,0,VW,VH); btn('exit',12,14,104,46,'◀ 返地圖','#2c2c33');")
R("btn('zin',VW-56,TOP+8,46,46,'＋','#24242a');","btn('quit',10,TOP+8,62,46,'離開','#2c2c33'); btn('zin',VW-56,TOP+8,46,46,'＋','#24242a');")
R("btn('title',VW/2+10,y0+0","btn('title',VW/2+10,y0+0",0)  # no-op check
R("btn('title',VW/2+10,y+420-60,120,44,'返主頁','#2c2c33');","btn('toMap',VW/2+10,y+420-60,120,44,'返地圖','#2c2c33'); if (o.reward!=null){ ctx.fillStyle='#ffd54a'; ctx.font='bold 16px '+FONT; ctx.textAlign='center'; ctx.fillText('收到冥幣 +'+o.reward,VW/2,y+420-76); }")
R("function frame(ts){ requestAnimationFrame(frame);","function frame(ts){ if (!OPEN){ RAF=0; return; } RAF=requestAnimationFrame(frame);")
R("window.addEventListener('resize',resize); resize();","window.addEventListener('resize',function(){ if (OPEN) resize(); });")
i=s.index("  (function load(cb){"); j=s.index("\n",i)
s=s[:i]+"""  function loadImgs(){ var M={flatbg:'bg_tw_flat',shopbg:'bg_tw_shop'}; ['eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_auntie','npc_guard','npc_it','npc_mis','npc_boss','npc_it_sit','npc_ken_sit','res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby','flatbg','shopbg'].forEach(function(k){ IMG[k]=SPR[M[k]||k]; }); }
  function open(){ loadImgs(); TS(); ROOT.classList.add('on'); OPEN=true; scene='title'; resize(); last=0; if (!RAF) RAF=requestAnimationFrame(frame); try{ Sound.setMode&&Sound.setMode('story'); }catch(e){} try{ window.Policy&&Policy.firstEnter&&Policy.firstEnter('tower'); }catch(e){} }
  function close(){ OPEN=false; ROOT.classList.remove('on'); joy=null; ptr=null; try{ save(); Sound.setMode&&Sound.setMode('village'); }catch(e){} if (typeof World!=='undefined') World.open(); }
  return { open:open, close:close, get on(){ return OPEN; } };"""+s[j:]
s="// ===================== 樓裡有鬼（由 /home/claude/lyg 獨立版移植；用 tools/port_tower.py 重新生成，唔好直接改）=====================\n"+s
open(D+'tower.js','w',encoding='utf-8').write(s)
a={'tw_flat':'flatbg','tw_shop':'shopbg'}
js="// 自動產生（tools/port_tower.py）：樓裡有鬼兩棟樓背景，加入 BG_SRC → SPR['bg_tw_flat'] / SPR['bg_tw_shop']\n"
for k,f in a.items(): js+="BG_SRC[%s]='data:image/webp;base64,%s';\n"%(json.dumps(k),base64.b64encode(open(f'{L}/assets/{f}.webp','rb').read()).decode())
for k in ['res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby']: js+="SPR_SRC[%s]='data:image/webp;base64,%s';\n"%(json.dumps(k),base64.b64encode(open(f'{L}/assets/{k}.webp','rb').read()).decode())
open(D+'tower_assets.js','w').write(js); print('ok',len(s),len(js))
