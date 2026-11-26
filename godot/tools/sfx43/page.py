import json,base64,html
meta=json.load(open('/home/claude/audio/out/cand_meta.json'))
src=json.load(open('/home/claude/audio/sfx/oga/sources.json'))
CATS=['副技','王牌技','狀態','兵器普攻','養成','裝備','魔王','戰報','陣容']
CATN={'副技':'副技發動（30 個模板 → 22 種聲）','王牌技':'王牌技（19 個 → 3 種重聲，比副技更有份量）','狀態':'狀態中招（音量細啲、短啲）','兵器普攻':'漂浮兵器四種普攻（出手一刻）','養成':'名鬼養成：融合升品、星級突破','裝備':'裝備：加工、一鍵穿戴、套裝湊齊、專屬物掉落','魔王':'魔王：收服、掉魂魄','戰報':'戰後統計 MVP','陣容':'陣容預設'}
def srcinfo(s):
    if s.startswith('ORIGINAL'): return '本組原創合成古箏撥弦（無第三方素材）'
    slug=s.split('/')[0]; r=src[slug]
    return '<a href="%s">%s</a>（%s，CC0）'%(r['url'],html.escape(r['title']),html.escape(r['author']))
H=['''<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>過勞鬼大作戰 補丁43 音效試聽</title><style>
body{background:#17121c;color:#f2e8d8;font-family:"Noto Sans TC","PingFang TC","Microsoft JhengHei",sans-serif;font-size:20px;margin:0;padding:18px;line-height:1.5}
h1{font-size:34px;color:#ffd27a;margin:6px 0}h2{font-size:28px;color:#ffb070;border-bottom:2px solid #5a3a2a;padding-bottom:4px;margin-top:34px}
.note{color:#cbbca8;font-size:18px}.card{background:#241b2b;border:1px solid #4a3654;border-radius:12px;padding:14px 16px;margin:14px 0}
.key{font-size:24px;font-weight:900;color:#fff}.where{color:#e0c9a6;font-size:19px;margin:2px 0 10px}
.c{display:flex;gap:12px;align-items:center;flex-wrap:wrap;padding:10px;border-radius:10px;margin:6px 0;background:#2f2338}
.c.def{outline:3px solid #d8a640}.c.pick{background:#3d3020}
button.play{font-size:22px;min-width:120px;padding:10px 16px;border-radius:10px;border:0;background:#c0392b;color:#fff;font-weight:900;cursor:pointer}
button.play:active{background:#e74c3c}.d{flex:1;min-width:240px}.d b{font-size:21px}
.s{font-size:16px;color:#b8a890}.s a{color:#9ad0ff}.tag{font-size:15px;background:#d8a640;color:#221;border-radius:6px;padding:1px 7px;margin-left:6px;font-weight:900}
label.r{font-size:19px;cursor:pointer;white-space:nowrap}input[type=radio]{transform:scale(1.6);margin-right:8px}
#out{width:100%;height:120px;font-size:17px;background:#100c14;color:#ffd27a;border:1px solid #555;border-radius:8px}
.bar{position:sticky;top:0;background:#17121cee;padding:8px 0;z-index:5}
.bar button{font-size:19px;padding:8px 14px;border-radius:8px;border:0;background:#4a3654;color:#fff;margin-right:8px}
</style></head><body>
<h1>過勞鬼大作戰・補丁 43 音效試聽</h1>
<div class="note">每個音效有 2–3 個候選，撳「▶ 播」試聽；金框＝而家已經入咗 sfx 分支遊戲嘅預設。揀好就剔「揀呢個」，最底會自動生成一段文字，複製俾統籌就得。<br>
全部素材：OpenGameArt.org 上逐個核實為 <b>CC0（公有領域，可免費商用、唔使署名）</b>；「古箏」係本組用程式原創合成（D F G A C 五聲，同背景音樂同一音階）。冇教堂鐘、聖詩、佛經、道士鈴、木魚。<br>
音量已統一（K 加權響度正規化）、頭尾裁乾淨、手機播放清楚。</div>
<div class="bar"><button onclick="stopAll()">■ 停</button><button onclick="document.getElementById('out').scrollIntoView()">⇩ 去揀選結果</button></div>
''']
idx=0
for cat in CATS:
    keys=[k for k,v in meta.items() if v['cat']==cat]
    if not keys: continue
    H.append('<h2>%s</h2>'%CATN[cat])
    for k in keys:
        v=meta[k]
        H.append('<div class="card" data-key="%s"><div class="key">%s</div><div class="where">用喺：%s</div>'%(k,k,html.escape(v['where'])))
        for c in v['c']:
            b64=base64.b64encode(open('/home/claude/audio/out/cand/'+c['file'],'rb').read()).decode()
            isdef=c['id']==v.get('default')
            ss='；'.join(sorted(set(srcinfo(s) for s in c['src'])))
            H.append('<div class="c%s" id="c_%s_%s"><button class="play" onclick="pl(%d)">▶ 播 %s</button><audio id="a%d" preload="auto" src="data:audio/ogg;base64,%s"></audio>'
                     '<div class="d"><b>%s</b>%s　<span class="s">%.2f 秒</span><div class="s">素材：%s</div></div>'
                     '<label class="r"><input type="radio" name="r_%s" value="%s" onchange="sel()"%s>揀呢個</label></div>'%(
                     ' def' if isdef else '',k,c['id'],idx,c['id'],idx,b64,html.escape(c['desc']),'<span class="tag">已入遊戲</span>' if isdef else '',c['dur'],ss,k,c['id'],' checked' if isdef else ''))
            idx+=1
        H.append('</div>')
H.append('''<h2>揀選結果（複製俾統籌）</h2><textarea id="out" readonly></textarea>
<div class="note">播唔到？請用 Chrome／Edge／Firefox 或 Android 瀏覽器開（iPhone Safari 舊版唔支援 ogg）。</div>
<script>
function stopAll(){document.querySelectorAll('audio').forEach(a=>{a.pause();a.currentTime=0})}
function pl(i){stopAll();var a=document.getElementById('a'+i);a.currentTime=0;a.play()}
function sel(){var o=[],ch=[];document.querySelectorAll('.card').forEach(c=>{var k=c.dataset.key;var r=c.querySelector('input:checked');
 c.querySelectorAll('.c').forEach(x=>x.classList.remove('pick'));if(r){document.getElementById('c_'+k+'_'+r.value).classList.add('pick');o.push(k+'='+r.value);
 var d=c.querySelector('.c.def input');if(d&&d.value!=r.value)ch.push(k+'='+r.value)}});
 document.getElementById('out').value='補丁43音效 老闆揀選（同預設唔同嘅）：'+(ch.length?ch.join('，'):'冇，全部照預設')+'\\n全部：'+o.join('，');
 try{localStorage.setItem('sfx43_pick',o.join(','))}catch(e){}}
try{var s=localStorage.getItem('sfx43_pick');if(s)s.split(',').forEach(p=>{var a=p.split('=');var e=document.querySelector('input[name="r_'+a[0]+'"][value="'+a[1]+'"]');if(e)e.checked=true})}catch(e){}
sel();
</script></body></html>''')
open('/home/claude/audio/out/HC_SFX43_Audition.html','w').write('\n'.join(H))
print(idx)
