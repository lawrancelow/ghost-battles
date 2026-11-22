import sys, numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi
src, names = sys.argv[1], sys.argv[2].split(',')
D='/home/claude/ghost-battles/godot/assets/spr/'
im=Image.open(src).convert('RGB'); q=np.asarray(im).max(2); rr=np.where(q.mean(1)>18)[0]; cc=np.where(q.mean(0)>18)[0]
im=im.crop((int(cc[0]),int(rr[0]),int(cc[-1])+1,int(rr[-1])+1)); arr=np.asarray(im).astype(int); print('sheet',im.size)
bg=np.median(arr[:6].reshape(-1,3),axis=0)
dist=np.sqrt(((arr-bg)**2).sum(2))
bgm=dist<22
lab,n=ndi.label(bgm)
border=list(set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]])))-{0})
outer=np.isin(lab,border)
sizes=ndi.sum(bgm,lab,range(1,n+1))
for i,sz in enumerate(sizes,1):
    if sz>2500: outer|=(lab==i)
al=(~outer).astype(np.uint8)*255
al=np.array(Image.fromarray(al).filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(0.7)))
# 光暈：同背景色差唔大嘅半透明
glow=(~outer)&(dist<70)&(arr.mean(2)>bg.mean())
al=np.where(glow, np.minimum(al, (np.clip((dist-22)/48,0,1)*200).astype(np.uint8)), al)
rgba=Image.fromarray(np.dstack([arr.astype(np.uint8),al]),'RGBA')
W,H=im.width/4,im.height/3
for r in range(3):
    for c in range(4):
        k=names[r*4+c]; x0,y0=int(c*W),int(r*H); x1,y1=int((c+1)*W),int((r+1)*H)
        m=al[y0:y1,x0:x1]>30; ys,xs=np.where(m)
        t=rgba.crop((x0+xs.min()-2,y0+ys.min()-2,x0+xs.max()+3,y0+ys.max()+3))
        t.save(D+k+'.webp',quality=92); print(k,t.size)
