import os
d=os.path.dirname(os.path.abspath(__file__))+'/src/'
html=open(d+'shell.html').read()
css=open(d+'style.css').read()
js='\n'.join(open(d+f).read() for f in ['assets.js','tower_assets.js','world_assets.js','lang.js','lang_zh.js','story.js','data.js','n30_data.js','guide.js','audio.js','art.js','special.js','meshanim.js','n30_rigs.js','limbdata.js','limbs.js','moves.js','moves_chain.js','moves_beast.js','moves_spirit.js','n30_moves.js','daily.js','daily_hero.js','daily_work.js','daily_plaza.js','daily_town.js','n30_daily.js','npc_antag.js','puppet.js','rigs.js','sprites.js','scene.js','phone.js','game.js','battle.js','rooms.js','office.js','scare.js','scare_squad.js','scare_ops.js','pantry.js','ghoststreet.js','graveyard.js','skits.js','standup.js','rivals.js','bonds_data.js','bonds.js','chatter_data.js','chatter.js','presence_data.js','presence.js','rework.js','station.js','station_props.js','station_fg.js','station_foes.js','street.js','sports.js','policy.js','world.js','tower.js','web.js'])+'\nstart();\n'
js=js.replace('𨋢','電梯')  # 𨋢字好多手機字型冇，統一寫「電梯」免得變方格
out=html.replace('/*CSS*/',css).replace('/*JS*/',js)
PREVIEW=os.environ.get('PREVIEW')=='1'
if PREVIEW: # 樣板版：自己一格存檔（第一次打開時複製正式版進度），標題加「樣板」，快取名不同
    js_pv=js.replace("const SAVE_KEY = 'ghostBattles_v1';","const SAVE_KEY = 'ghostBattles_preview'; try { if (!localStorage.getItem(SAVE_KEY) && localStorage.getItem('ghostBattles_v1')) localStorage.setItem(SAVE_KEY, localStorage.getItem('ghostBattles_v1')); } catch (e) {}",1)
    assert js_pv!=js; out=html.replace('/*CSS*/',css).replace('/*JS*/',js_pv).replace('<title>','<title>（樣板）',1)
open(os.path.dirname(os.path.abspath(__file__))+'/'+os.environ.get('OUT','GhostBattles.html'),'w').write(out)
print(len(out))
# ---- 網址版（GitHub Pages）：PWA 外殼 ----
import re,json
root=os.path.dirname(os.path.abspath(__file__))
site=root+('/site_preview' if PREVIEW else '/site'); os.makedirs(site,exist_ok=True)
ver=re.search(r"GAME_VER = '([^']+)'",out).group(1)
pwa='''<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="icon-192.png">
<link rel="icon" type="image/png" href="icon-192.png">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="過勞鬼">
'''
open(site+'/index.html','w').write(out.replace('<meta name="theme-color"',pwa+'<meta name="theme-color"',1))
json.dump({"name":"過勞鬼大作戰","short_name":"過勞鬼","start_url":"./","scope":"./","display":"standalone","orientation":"portrait","background_color":"#16131b","theme_color":"#16131b",
 "icons":[{"src":"icon-192.png","sizes":"192x192","type":"image/png"},{"src":"icon-512.png","sizes":"512x512","type":"image/png","purpose":"any"},{"src":"icon-512.png","sizes":"512x512","type":"image/png","purpose":"maskable"}]},
 open(site+'/manifest.webmanifest','w'),ensure_ascii=False,indent=1)
open(site+'/sw.js','w').write('''// 過勞鬼離線快取：有網絡時拿最新版，沒網絡時用上次的版本
const C='%s';
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(['./','index.html','manifest.webmanifest','icon-192.png','icon-512.png'])).then(()=>self.skipWaiting()));});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==C&&k.slice(0,3)===C.slice(0,3)).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));});
self.addEventListener('fetch',e=>{const u=new URL(e.request.url);if(e.request.method!=='GET'||u.origin!==location.origin)return;
  e.respondWith(fetch(e.request,{cache:'no-store'}).then(r=>{const cp=r.clone();caches.open(C).then(c=>c.put(e.request,cp));return r;}).catch(()=>caches.match(e.request).then(r=>r||caches.match('index.html'))));});
'''%(('gbp-' if PREVIEW else 'gb-')+ver))
open(site+'/.nojekyll','w').write('')
print('site',ver)
