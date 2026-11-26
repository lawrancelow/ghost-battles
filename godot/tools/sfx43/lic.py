import json,os
src=json.load(open('/home/claude/audio/sfx/oga/sources.json'))
meta=json.load(open('/home/claude/audio/out/cand_meta.json'))
used={}   # slug -> set of files
cand_src={}
for k,v in meta.items():
    for c in v['c']:
        for s in c['src']:
            slug=s.split('/')[0]
            used.setdefault(slug,set()).add(s.split('/')[-1])
L=['# 補丁 43 音效：來源與授權（sfx 組，2026-11-26）','',
 '規矩：只用 CC0（公有領域）素材；每個素材都喺 OpenGameArt.org 原頁核實過授權欄「CC0」（唯一授權）先下載。',
 '另有「本組原創」：用程式即場合成嘅古箏撥弦（Karplus-Strong 物理撥弦，D F G A C 五聲，同遊戲背景音樂同一音階），冇用任何第三方素材，版權屬本遊戲。',
 '所有遊戲用音效都係用以下素材剪輯、疊層、變調、濾波、加殘響、響度正規化（K 加權，副技 −18 LUFS、王牌 −15、狀態 −21、普攻 −22、UI −19）、限幅 −1 dBFS 後重新輸出（44.1 kHz 單聲道 ogg）。',
 '','CC0 1.0 授權全文：https://creativecommons.org/publicdomain/zero/1.0/ （可免費商用、可改、唔使署名；下面仍然記低作者以示尊重）','',
 '| 素材包 | 作者（OGA 上傳者） | 授權 | 來源網址 | 用咗嘅檔 | 備註 |','|---|---|---|---|---|---|']
NOTE={'catching-fire':'衍生自 freesound.org/people/qubodup/sounds/159725（已核實 CC0）','energy-drain':'作者 2024-06-23 改為 CC0（頁面註明，壓縮檔內舊限制可忽略）','ice-spells':'原始素材來自 pdsounds（公有領域）','50-rpg-sound-effects':'包內 license.txt：CC0（Kenney）','interface-sounds':'包內 License.txt：CC0（Kenney）','swish-bamboo-stick-weapon-swhoshes':'包內 txt：public domain / CC0','85-short-music-jingles':'Kenney，CC0'}
for slug in sorted(used):
    if slug.startswith('ORIGINAL'): continue
    r=src[slug]
    L.append('| %s | %s | CC0 1.0 | %s | %s | %s |'%(r['title'],r['author'],r['url'],'、'.join(sorted(used[slug])),NOTE.get(slug,'')))
L+=['| 古箏撥弦（本組原創合成） | 過勞鬼大作戰 sfx 組 | 本遊戲自有 | /home/claude/audio/tools/zheng.py | — | 冇第三方素材 |','',
 '## 每個遊戲音效用咗乜素材','','| 音效 key | 類別 | 用喺 | 揀咗 | 素材 |','|---|---|---|---|---|']
for k,v in meta.items():
    d=v.get('default','A'); c=[x for x in v['c'] if x['id']==d][0]
    L.append('| %s | %s | %s | %s：%s | %s |'%(k,v['cat'],v['where'],d,c['desc'],'；'.join(s if s.startswith('ORIGINAL') else s.split('/')[0]+'/'+s.split('/')[-1] for s in c['src'])))
L+=['','試聽頁其他候選嘅素材全部喺上面素材包表入面（同一批 CC0 素材）。未用：AI 生成嘅 SFXMint 資料集（CC0 但需 Steam AI 披露，已排除）；CC-BY／CC-BY-SA／GPL 素材一律唔用。']
t='\n'.join(L)+'\n'
open('/home/claude/audio/sfx/LICENSES.md','w').write(t)
open('/home/claude/wt/sfx/godot/assets/snd/LICENSES_sfx43.md','w').write(t)
print(len(used))
