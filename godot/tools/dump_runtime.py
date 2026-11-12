# 用 Playwright 跑網頁版，等所有模塊載入、補丁打完，導出最終數據表 → godot/data/core.json
import json, sys
from playwright.sync_api import sync_playwright
URL = sys.argv[1]; OUT = sys.argv[2]
NAMES = ['SCENES','SCENE_ORDER','PRAISE_CHOP','PRAISE_RICE','PRAISE_CRAFT','PRAISE_KIND','LEVEL_UNLOCKS','CHATTER','FLAVOR','WIN_QUIPS','LOSE_QUIPS','STANDUP','SKILLS','COMBOS','GHOSTS','FODDER','NICKS','POSTS','STAT_NAMES','BUILDINGS','BLD_ORDER','ENEMY_T','CHAPTERS','QUESTS','RES_NAMES','SPEAKER_ART']
JS = """(names)=>{const ser=(v,seen)=>{if(typeof v==='function')return '__fn__:'+v.toString().slice(0,400);if(v&&typeof v==='object'){if(v instanceof HTMLElement)return null;if(seen.has(v))return '__cycle__';seen.add(v);const o=Array.isArray(v)?v.map(x=>ser(x,seen)):Object.fromEntries(Object.entries(v).map(([k,x])=>[k,ser(x,seen)]));seen.delete(v);return o;}return v;};
const out={};for(const n of names){try{out[n]=ser(eval(n),new Set());}catch(e){out[n]=null;}}
out.LANG_ZH=LANG.ZH; out.GAME_VER=GAME_VER; return JSON.stringify(out);}"""
with sync_playwright() as p:
    b = p.chromium.launch(); pg = b.new_page(viewport={'width':390,'height':844})
    pg.goto(URL); pg.wait_for_timeout(5000)
    s = pg.evaluate(JS, NAMES)
    open(OUT,'w').write(s)
    d = json.loads(s); print('ver', d['GAME_VER'], 'quests', len(d['QUESTS']), 'scenes', len(d['SCENES']), 'zh', len(d['LANG_ZH']), 'posts', list(d['POSTS'].keys()))
    b.close()
