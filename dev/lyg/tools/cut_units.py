# 入屋背景：讀 core/unit_layouts.json，將每個 key 嘅原圖（src）裁到 crop 範圍（全闊），存 assets/<img>.webp（質素 80）
# 新圖到：喺 unit_layouts.json 加／改一個 key（img、src、crop、floor…），再行呢個 script，之後行 port_tower.py
import json, os
from PIL import Image
D=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
L=json.load(open(D+'/core/unit_layouts.json',encoding='utf-8'))
for k,l in L.items():
    src=l.get('src')
    if not src or not os.path.exists(src): print('skip',k,src); continue
    im=Image.open(src).convert('RGB'); assert im.size==(l['W'],l['H']),(k,im.size)
    c=im.crop((0,l['crop'][0],l['W'],l['crop'][1]))
    out=D+'/assets/'+l['img']+'.webp'; c.save(out,'WEBP',quality=80,method=6)
    print(k,c.size,os.path.getsize(out)//1024,'KB')
