#!/usr/bin/env python3
# cut.py <sheet.jpg> <cols> <rows> <outdir> name1,name2,...  整格圖切開＋自檢（主體不碰格線、數量正確）
import sys,os
from PIL import Image
import numpy as np
from scipy import ndimage as nd
P,cols,rows,out=sys.argv[1],int(sys.argv[2]),int(sys.argv[3]),sys.argv[4]; names=sys.argv[5].split(',')
os.makedirs(out,exist_ok=True)
im=Image.open(P).convert('RGB'); a=np.asarray(im).astype(int); H,W=a.shape[:2]
bg=np.median(np.concatenate([a[:6].reshape(-1,3),a[-6:].reshape(-1,3),a[:,:6].reshape(-1,3),a[:,-6:].reshape(-1,3)]),axis=0)
d=np.abs(a-bg).sum(2); fg=d>40
fg=nd.binary_opening(fg,iterations=1)
L,n=nd.label(nd.binary_dilation(fg,iterations=int(os.environ.get('DIL','14'))))
cells={}
for i,s in enumerate(nd.find_objects(L)):
    m=(L[s]==i+1)&fg[s]
    if m.sum()<600: continue
    ys,xs=np.nonzero(m); cy=s[0].start+ys.mean(); cx=s[1].start+xs.mean()
    k=min(rows-1,int(cy//(H/rows)))*cols+min(cols-1,int(cx//(W/cols)))
    nb=[s[1].start+xs.min(),s[0].start+ys.min(),s[1].start+xs.max()+1,s[0].start+ys.max()+1]
    b=cells.get(k); cells[k]=nb if b is None else [min(b[0],nb[0]),min(b[1],nb[1]),max(b[2],nb[2]),max(b[3],nb[3])]
bad=[]
for k,nm in enumerate(names):
    if k not in cells: bad.append(nm+':缺'); continue
    x0,y0,x1,y1=cells[k]; r,c=divmod(k,cols)
    if x0<=2 or y0<=2 or x1>=W-2 or y1>=H-2: bad.append(nm+':碰畫布邊')
    cw,ch=W/cols,H/rows
    if x0<c*cw-cw*0.12 or x1>(c+1)*cw+cw*0.12 or y0<r*ch-ch*0.12 or y1>(r+1)*ch+ch*0.12: bad.append(nm+':跨格')
    p=6; box=(max(0,x0-p),max(0,y0-p),min(W,x1+p),min(H,y1+p)); crop=im.crop(box)
    dd=d[box[1]:box[3],box[0]:box[2]]
    # 由外向內 flood 背景，保留主體內部的淺色
    near=dd<=40; lab,_=nd.label(near); edge=set(lab[0])|set(lab[-1])|set(lab[:,0])|set(lab[:,-1]); edge.discard(0)
    bgm=np.isin(lab,list(edge)); al=np.where(bgm,0,255).astype(np.uint8)
    al=np.asarray(Image.fromarray(al).filter(__import__('PIL.ImageFilter',fromlist=['x']).GaussianBlur(0.8)))
    rgba=np.dstack([np.asarray(crop),al]); Image.fromarray(rgba,'RGBA').save(f'{out}/{nm}.png')
print('cells',len(cells),'/',len(names),'BAD:',bad if bad else '無')
