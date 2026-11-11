# 切 Q 版住客圖：gen_art/gb_tower_chibi_{a,b}.png（5 欄 x 2 行；上行平常、下行驚嚇）
# → assets/res_xxx.webp（取代舊寫實圖）＋ assets/res_xxx_scared.webp ＋ core/ppl_meta.json
# 做法：淺灰底係純色 → 按「連通塊」分配去最近嘅格（唔會切斷越界嘅手腳／飛出去嘅物件），
#       背景＝由格邊連通嘅灰色＋被包住嘅大片純灰；邊緣軟 alpha ＋ 反混色（冇灰邊）。
#       腳底＝最大連通塊（身體）最底；平常／驚嚇兩張同一比例，腳底對齊。
import json, sys, numpy as np
from PIL import Image
from scipy import ndimage as ndi
GA='/home/claude/gen_art/'; AS='/home/claude/lyg/assets/'
SHEETS={'a':['res_gamer','res_uncle','res_granny','res_helper','res_mjaunty'],
        'b':['res_shopper','res_collector','res_guard','res_ot','res_gym']}
OUT_H=420          # 平常圖輸出高度（同舊圖／npc_* 一樣 420）
DBG='--dbg' in sys.argv
meta={}

def matte(rgb, bg):
    d=np.abs(rgb-bg).max(2)
    fg=d>12
    # 背景候選：灰（d<=12）；外部背景＝同圖邊連通
    bgl=~fg
    lab,n=ndi.label(bgl)
    edge=set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]])))-{0}
    R=np.isin(lab,list(edge))
    # 被包住嘅純灰大片（例如手臂同身之間）都要透明
    sizes=ndi.sum(np.ones_like(d),lab,index=np.arange(1,n+1))
    pure=ndi.mean(d,lab,index=np.arange(1,n+1))
    for i in range(n):
        if (i+1) in edge: continue
        if sizes[i]>=60 and pure[i]<5: R|=lab==(i+1)
    a=np.ones(d.shape,float)
    ring=ndi.binary_dilation(R,iterations=2)&~R
    soft=np.clip((d-5)/55.0,0,1)
    a[R]=0
    a[ring]=soft[ring]
    # 反混色：P=a*F+(1-a)*B
    F=rgb.copy()
    m=a>0.02
    F[m]=(rgb[m]-(1-a[m,None])*bg)/a[m,None]
    F=np.clip(F,0,255)
    return a,F,fg

for sh,keys in SHEETS.items():
    im=np.asarray(Image.open(GA+'gb_tower_chibi_%s.png'%sh).convert('RGB')).astype(float)
    H,W,_=im.shape; bg=np.median(im[:6].reshape(-1,3),0)
    for row in (0,1):
        band=im[row*H//2:(row+1)*H//2]
        a,F,fg=matte(band,bg)
        on=a>0.02
        lab,n=ndi.label(ndi.binary_dilation(on,iterations=1),structure=np.ones((3,3)))
        cw=W/5.0
        cells=[np.zeros(on.shape,bool) for _ in range(5)]
        for i in range(1,n+1):
            m=lab==i; cnt=m.sum()
            if cnt<12: continue
            ys,xs=np.nonzero(m); cx=xs.mean(); c=int(min(4,max(0,cx//cw)))
            cells[c]|=m
        for c,k in enumerate(keys):
            m=cells[c]&on
            ys,xs=np.nonzero(m)
            # 身體＝最大連通塊；腳底＝佢最底一行
            l2,n2=ndi.label(m,structure=np.ones((3,3))); sz=ndi.sum(m,l2,index=np.arange(1,n2+1)); body=l2==(int(np.argmax(sz))+1)
            by=np.nonzero(body)[0]; foot=by.max(); top=ys.min(); bot=ys.max()
            x0,x1=xs.min(),xs.max()
            meta.setdefault(k,{})['row%d'%row]=dict(top=int(top),foot=int(foot),bot=int(bot),x0=int(x0),x1=int(x1),bodyTop=int(by.min()))
            alpha=np.where(m,a,0)
            rgba=np.dstack([F,alpha*255]).astype(np.uint8)
            meta[k]['_img%d'%row]=(rgba,int(top),int(bot),int(foot),int(x0),int(x1))

out={}
for k,M in meta.items():
    rgbaN,tN,bN,fN,x0N,x1N=M['_img0']; rgbaS,tS,bS,fS,x0S,x1S=M['_img1']
    s=OUT_H/float(fN-tN+1)            # 平常圖：頭頂→腳底 = 420
    def save(rgba,t,b,f,x0,x1,name):
        crop=rgba[t:max(b,f)+1, max(0,x0-2):x1+3]
        img=Image.fromarray(crop,'RGBA'); w=max(1,round(img.width*s)); h=max(1,round(img.height*s))
        img=img.resize((w,h),Image.LANCZOS); img.save(AS+name+'.webp','WEBP',quality=92,method=6)
        return h, (max(b,f)-f)*s     # 圖高、腳底以下（飛出去嘅物件）嘅高度
    hN,belowN=save(rgbaN,tN,bN,fN,x0N,x1N,k)
    hS,belowS=save(rgbaS,tS,bS,fS,x0S,x1S,k+'_scared')
    # 顯示：平常圖按高度 h 畫（腳底對地）；驚嚇圖用同一比例 → 高度 h*s，腳底以下部分 foot 分率
    out[k]={'n':{'foot':round(belowN/hN,4)}, 's':{'k':round(hS/hN,4),'foot':round(belowS/hS,4)},
            'size':{'n':[Image.open(AS+k+'.webp').size],'s':[Image.open(AS+k+'_scared.webp').size]}}
    print(k,'normal',Image.open(AS+k+'.webp').size,'below',round(belowN,1),'| scared',Image.open(AS+k+'_scared.webp').size,'k',out[k]['s']['k'],'below',round(belowS,1))
json.dump(out,open('/home/claude/lyg/core/ppl_meta.json','w'),ensure_ascii=False,indent=1)
print('ok')
