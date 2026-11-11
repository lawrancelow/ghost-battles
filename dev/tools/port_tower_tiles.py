# 樓裡有鬼：大樓剖面新格（gen_art/gb_tower_tiles2.jpg，4x2 共 8 格）切圖 → webp → gb/src/tower_tiles_assets.js
# 生成 SPR_SRC['twt_corr1'] 等；pangsa.js（patch_v8_tiles.py）喺 bake2 透過 IMG/SPR 讀取。
# 唔好加入 port_tower.py（另有同事改緊）；build.py 要將 tower_tiles_assets.js 放喺 sprites.js／tower.js 之前。
import base64, json, os
from PIL import Image
import numpy as np
SRC='/home/claude/gen_art/gb_tower_tiles2.jpg'
OUTD='/home/claude/lyg/assets/'          # 同其他樓裡有鬼素材放埋一齊（lyg 獨立版都用得）
JS='/home/claude/gb/src/tower_tiles_assets.js'
NAMES=[['corr1','corr2','stairR','stairL'],['lift','roof','lobby','carpark']]   # stairR＝由左下行上右上；stairL＝由右下行上左上

im=Image.open(SRC).convert('RGB'); L=np.asarray(im.convert('L')).astype(float); H,W=L.shape

def gutters(prof, n):
    # 搵最暗嘅連續區（格線），回傳 n+1 條格線嘅 (起,止)
    dark=prof<25; runs=[]; i=0
    while i<len(prof):
        if dark[i]:
            j=i
            while j+1<len(prof) and dark[j+1]: j+=1
            runs.append((i,j)); i=j+1
        else: i+=1
    runs=[r for r in runs if r[1]-r[0]>=12 or r[0]==0 or r[1]==len(prof)-1]   # 格線至少 13px（邊框可以貼邊）
    assert len(runs)==n+1,(runs,n)
    return runs

def cells(prof,n):
    g=gutters(prof,n); return [(g[i][1]+1,g[i+1][0]-1) for i in range(n)]

rows=cells(L.mean(1),2)
INS=3   # 每邊再內縮 3px，避免切到格線／隔籬格嘅暗邊
os.makedirs(OUTD,exist_ok=True)
js="// 自動產生（tools/port_tower_tiles.py）：樓裡有鬼大樓剖面新格（gb_tower_tiles2）→ SPR['twt_*']\n"
for ri,(y0,y1) in enumerate(rows):
    cols=cells(L[y0:y1+1].mean(0),4)
    for ci,(x0,x1) in enumerate(cols):
        nm=NAMES[ri][ci]
        c=im.crop((x0+INS,y0+INS,x1+1-INS,y1+1-INS)).resize((416,416),Image.LANCZOS)   # 統一 416x416，JS 用比例座標
        a=np.asarray(c.convert('L')).astype(float)
        assert a[:,:2].mean()>9 and a[:,-2:].mean()>9 and a[:2].mean()>9 and a[-2:].mean()>9, ('切到格線', nm)
        p=OUTD+'twt_'+nm+'.webp'; c.save(p,'WEBP',quality=84,method=6)
        js+="SPR_SRC[%s]='data:image/webp;base64,%s';\n"%(json.dumps('twt_'+nm),base64.b64encode(open(p,'rb').read()).decode())
        print(nm,(x0,y0,x1,y1),os.path.getsize(p))
open(JS,'w').write(js); print('ok',JS,len(js))
