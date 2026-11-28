#!/bin/bash
# lay.sh <layers名>：把 _sheet_raw.jpg 按連通塊自動切成 char_NN.png（由左到右、由上到下），不依賴格線
python3 - "/home/claude/meeting/vil2/art/layers/$1" <<'P'
import sys,os,glob
from PIL import Image,ImageFilter
import numpy as np
from scipy import ndimage as nd
O=sys.argv[1]; im=Image.open(O+'/_sheet_raw.jpg').convert('RGB'); a=np.asarray(im).astype(int); H,W=a.shape[:2]
for f in glob.glob(O+'/char_*.png'): os.remove(f)
bg=np.median(np.concatenate([a[8:14].reshape(-1,3),a[-14:-8].reshape(-1,3)]),axis=0)
d=np.abs(a-bg).sum(2); fg=d>40; fg[:6]=0; fg[-6:]=0; fg[:,:6]=0; fg[:,-6:]=0
fg=nd.binary_opening(fg,iterations=1)
L,n=nd.label(nd.binary_dilation(fg,iterations=int(os.environ.get('DIL','8'))))
bx=[]
for i,s in enumerate(nd.find_objects(L)):
    m=(L[s]==i+1)&fg[s]
    if m.sum()<1500: continue
    bx.append((s[0].start,s[1].start,s[0].stop,s[1].stop,i+1))
bx.sort(key=lambda b:(round((b[0]+b[2])/2/(H/3)),b[1]))
for k,(y0,x0,y1,x1,lab) in enumerate(bx):
    crop=np.asarray(im.crop((x0,y0,x1,y1))); dd=d[y0:y1,x0:x1]; own=(L[y0:y1,x0:x1]==lab)
    near=(dd<=40)|~own; lb,_=nd.label(near); e=set(lb[0])|set(lb[-1])|set(lb[:,0])|set(lb[:,-1]); e.discard(0)
    al=np.where(np.isin(lb,list(e)),0,255).astype(np.uint8)
    al=np.asarray(Image.fromarray(al).filter(ImageFilter.GaussianBlur(0.8)))
    Image.fromarray(np.dstack([crop,al]),'RGBA').save(f'{O}/char_{k+1:02d}.png')
    print(f'char_{k+1:02d}',(x0,y0,x1,y1))
P
