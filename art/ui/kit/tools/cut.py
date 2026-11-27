# 用法：cut.py out_prefix W H nx ny tile1 tile2 ...（tiles 按行優先；品紅底去背、連通塊切件）
import sys, numpy as np
from PIL import Image
from scipy import ndimage
pre=sys.argv[1]; W=int(sys.argv[2]); H=int(sys.argv[3]); nx=int(sys.argv[4]); ny=int(sys.argv[5]); tiles=sys.argv[6:]
tw,th=W//nx,H//ny
sheet=Image.new("RGB",(W,H))
for k,f in enumerate(tiles):
    cx,cy=k%nx,k//nx
    sheet.paste(Image.open(f).convert("RGB").resize((tw,th),Image.LANCZOS),(cx*tw,cy*th))
a=np.asarray(sheet).astype(int)
r,g,b=a[...,0],a[...,1],a[...,2]
mag=(r>200)&(b>200)&(g<90)
alpha=np.where(mag,0,255).astype(np.uint8)
# 邊緣去品紅溢色
edge=ndimage.binary_dilation(mag,iterations=2)&~mag
rgb=a.copy()
m2=edge&(r>g+40)&(b>g+40)
rgb[m2]=np.stack([np.minimum(r,g+30),g,np.minimum(b,g+30)],-1)[m2]
alpha=ndimage.binary_erosion(alpha>0,iterations=1).astype(np.uint8)*255
rgba=np.dstack([rgb.astype(np.uint8),alpha])
Image.fromarray(rgba,"RGBA").save(pre+"_sheet.png")
lab,n=ndimage.label(ndimage.binary_closing(alpha>0,iterations=3))
objs=ndimage.find_objects(lab); out=[]
for i,s in enumerate(objs):
    h=s[0].stop-s[0].start; w=s[1].stop-s[1].start
    if h*w<1500: continue
    piece=rgba[s].copy(); piece[...,3]=np.where(lab[s]==i+1,piece[...,3],0)
    out.append((s[0].start,s[1].start,piece,w,h))
out.sort(key=lambda t:(t[0]//60,t[1]))
for j,(y,x,p,w,h) in enumerate(out):
    fn=f"{pre}_{j:02d}.png"; Image.fromarray(p,"RGBA").save(fn); print(fn,x,y,w,h)
