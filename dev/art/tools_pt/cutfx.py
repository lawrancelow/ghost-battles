# 黑底特效：亮度做 alpha（顏色除返 alpha），按「由上而下、由左而右」切開
import sys, numpy as np
from PIL import Image
from scipy import ndimage
im=np.array(Image.open(sys.argv[1]).convert('RGB')).astype(float); names=sys.argv[2].split(','); h=int(sys.argv[3]); cols=int(sys.argv[4]) if len(sys.argv)>4 else 4; rows=int(sys.argv[5]) if len(sys.argv)>5 else 2
a=np.clip((im.max(2)-12)/220,0,1)
col=np.clip(im/np.maximum(a[...,None],1e-3),0,255)
H,W=a.shape; cw,ch=W/cols,H/rows
for i,nm in enumerate(names):
    if nm=='-': continue
    x0,y0=int((i%cols)*cw),int((i//cols)*ch); sub_a=a[y0:int(y0+ch),x0:int(x0+cw)]; sub_c=col[y0:int(y0+ch),x0:int(x0+cw)]
    m=sub_a>0.04; ys,xs=np.where(m)
    if not len(ys): continue
    b=(max(0,ys.min()-4),min(m.shape[0],ys.max()+5),max(0,xs.min()-4),min(m.shape[1],xs.max()+5))
    rgba=np.dstack([sub_c,sub_a*255])[b[0]:b[1],b[2]:b[3]].astype(np.uint8)
    o=Image.fromarray(rgba)
    s=h/max(o.size); o=o.resize((max(1,round(o.width*s)),max(1,round(o.height*s))),Image.LANCZOS) if s<1 else o
    o.save(f'/home/claude/gb/art/patrol/{nm}.png'); print(nm,o.size)
