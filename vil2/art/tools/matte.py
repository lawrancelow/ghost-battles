# matte.py out.png W H viewW blackTop:whiteTop:ty blackBot:whiteBot:ty
import sys,numpy as np
from PIL import Image
out,W,H,vw=sys.argv[1],int(sys.argv[2]),int(sys.argv[3]),float(sys.argv[4])
segs=[a.split(':') for a in sys.argv[5:]]
s=Image.open(segs[0][0]).width/vw
Wp,Hp=round(W*s),round(H*s)
Bc=np.zeros((Hp,Wp,3),np.float32);Wc=np.zeros((Hp,Wp,3),np.float32)
for b,w,ty in segs:
    y=round(int(ty)*s);bi=np.asarray(Image.open(b).convert('RGB'),np.float32);wi=np.asarray(Image.open(w).convert('RGB'),np.float32)
    h=min(bi.shape[0],Hp-y);Bc[y:y+h]=bi[:h,:Wp];Wc[y:y+h]=wi[:h,:Wp]
a=1-np.clip((Wc-Bc).mean(2)/255,0,1)
a=np.where(a<0.06,0,a);a=np.where(a>0.94,1,a)
col=np.clip(Bc/np.maximum(a[...,None],1e-3),0,255)
rgba=np.dstack([col,a*255]).astype(np.uint8)
Image.fromarray(rgba,'RGBA').save(out);print(out,rgba.shape)
