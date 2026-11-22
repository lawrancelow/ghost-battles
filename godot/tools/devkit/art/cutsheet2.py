import sys, numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi
src, names = sys.argv[1], sys.argv[2].split(',')
D='/home/claude/ghost-battles/godot/assets/spr/'
im=Image.open(src).convert('RGB'); q=np.asarray(im).max(2); rr=np.where(q.mean(1)>18)[0]; cc=np.where(q.mean(0)>18)[0]
im=im.crop((int(cc[0]),int(rr[0]),int(cc[-1])+1,int(rr[-1])+1)); arr=np.asarray(im).astype(int)
bg=np.median(np.concatenate([arr[:4].reshape(-1,3),arr[:,:4].reshape(-1,3)]),axis=0)
dist=np.sqrt(((arr-bg)**2).sum(2))
# 背景＝由外框連通、同背景色極近（9 鄰域變化細）嘅像素
flat=ndi.maximum_filter(dist,3)<16
lab,n=ndi.label(flat)
border=list(set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]])))-{0})
outer=np.isin(lab,border)
fg=~outer
fg=ndi.binary_opening(fg,iterations=1)
al=(fg*255).astype(np.uint8)
al=np.array(Image.fromarray(al).filter(ImageFilter.GaussianBlur(0.6)))
# 物件：將前景膨脹 10px 合併碎片，取最大 12 個
big=ndi.binary_dilation(fg,iterations=int(sys.argv[3]) if len(sys.argv)>3 else 10)
L,nn=ndi.label(big); sz=ndi.sum(big,L,range(1,nn+1))
ids=[i+1 for i in np.argsort(sz)[::-1][:12]]
objs=[]
for i in ids:
    ys,xs=np.where((L==i)&fg); objs.append((ys.mean(),xs.mean(),xs.min(),ys.min(),xs.max(),ys.max(),i))
H=im.height; objs.sort(key=lambda o:(int(o[0]/(H/3)),o[1]))
rgba=np.dstack([arr.astype(np.uint8),al])
for k,o in zip(names,objs):
    m=(L==o[6]); a=np.where(m,al,0)
    t=Image.fromarray(np.dstack([arr.astype(np.uint8),a]),'RGBA').crop((o[2]-2,o[3]-2,o[4]+3,o[5]+3))
    t.save(D+k+'.webp',quality=92); print(k,t.size)
