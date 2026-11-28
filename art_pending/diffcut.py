#!/usr/bin/env python3
# diffcut.py <layers目錄> <原圖> [THR]：用「原圖 − 純背景」的差異直接從原圖摳角色（Gemini 純背景逐像素對齊時最忠於原圖）。
# 若有 _inplace_raw.jpg 就拿它的「有顏色區域」做粗遮罩，去掉背景補畫造成的雜訊。輸出 chars_inplace.png、char_NN.png、layout.json、_compare.jpg
import sys,os,json,glob
from PIL import Image,ImageFilter
import numpy as np
from scipy import ndimage as nd
from skimage import color
O,SRC=sys.argv[1],sys.argv[2]; THR=float(sys.argv[3]) if len(sys.argv)>3 else 14
src=Image.open(SRC).convert('RGB'); W,H=src.size
bg=Image.open(O+'/_bg_raw.jpg').convert('RGB').resize((W,H),Image.LANCZOS); bg.save(O+'/bg.png')
a=color.rgb2lab(np.asarray(src)/255.); b=color.rgb2lab(np.asarray(bg)/255.)
d=np.sqrt(((a-b)**2).sum(2)); d=nd.gaussian_filter(d,1.2)
fg=d>THR
ipp=O+'/_inplace_raw.jpg'
if os.path.exists(ipp) and os.environ.get('NOIP')!='1':
    ip=np.asarray(Image.open(ipp).convert('RGB').resize((W,H),Image.LANCZOS)).astype(float)/255.
    hsv=color.rgb2hsv(ip); col=(hsv[...,1]>0.18)|(hsv[...,2]<0.45)   # 有顏色或夠深＝角色；淺灰線稿不算
    col=nd.binary_opening(col,iterations=2); coarse=nd.binary_dilation(col,iterations=int(os.environ.get('GROW','14')))
    fg&=coarse
fg=nd.binary_closing(fg,iterations=3); fg=nd.binary_fill_holes(fg); fg=nd.binary_opening(fg,iterations=2)
L,n=nd.label(fg); sizes=nd.sum(fg,L,range(1,n+1)); MINA=int(os.environ.get('MINA','1500'))
keep=np.isin(L,[i+1 for i,s in enumerate(sizes) if s>=MINA])
alpha=np.asarray(Image.fromarray((keep*255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(1.0)))
rgba=np.dstack([np.asarray(src),alpha]); Image.fromarray(rgba,'RGBA').save(O+'/chars_inplace.png')
for f in glob.glob(O+'/char_*.png'): os.remove(f)
L,n=nd.label(nd.binary_dilation(keep,iterations=int(os.environ.get('DIL','3')))); objs=nd.find_objects(L); out=[];k=0
for i in sorted(range(n),key=lambda i:objs[i][1].start):
    s=objs[i]; m=(L[s]==i+1)&keep[s]
    if m.sum()<MINA: continue
    k+=1; y0,x0,y1,x1=s[0].start,s[1].start,s[0].stop,s[1].stop
    al=np.where(m,alpha[y0:y1,x0:x1],0).astype(np.uint8)
    Image.fromarray(np.dstack([np.asarray(src)[y0:y1,x0:x1],al]),'RGBA').save(f'{O}/char_{k:02d}.png')
    out.append({'file':f'char_{k:02d}.png','x':int(x0),'y':int(y0),'w':int(x1-x0),'h':int(y1-y0),'touch_edge':bool(x0<=1 or y0<=1 or x1>=W-1 or y1>=H-1)})
json.dump({'size':[W,H],'source':os.path.basename(SRC),'bg':'bg.png','note':'差異摳圖：角色像素直接取自原圖（原圖−Gemini 純背景），座標即原圖座標，可直接疊回 bg.png','chars':out},open(O+'/layout.json','w'),ensure_ascii=False,indent=1)
T=[src,bg]; c=bg.copy(); ci=Image.open(O+'/chars_inplace.png'); c.paste(ci,(0,0),ci); T.append(c)
w=Image.new('RGB',(W,H),(255,255,255)); w.paste(ci,(0,0),ci); T.append(w)
S=Image.new('RGB',(len(T)*640+10*(len(T)+1),int(640*H/W)+20),(20,16,24))
for i,t in enumerate(T): S.paste(t.resize((640,int(640*H/W))),(10+i*650,10))
S.save(O+'/_compare.jpg',quality=88)
print(os.path.basename(O.rstrip('/')),'chars',k,[(c['file'],c['w'],c['h'],c['touch_edge']) for c in out])
