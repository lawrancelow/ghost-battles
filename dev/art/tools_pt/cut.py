# 用法：python3 cut.py <黑底.png> <白底.png> <名1,名2,...>（按「由上而下、由左而右」次序；- = 跳過）
import sys, numpy as np
from PIL import Image
from scipy import ndimage
B=np.array(Image.open(sys.argv[1]).convert('RGB')).astype(float); W=np.array(Image.open(sys.argv[2]).convert('RGB')).astype(float)
names=sys.argv[3].split(','); h=int(sys.argv[4]) if len(sys.argv)>4 else 300
a=1-np.clip((W-B).mean(2)/255,0,1); a[a<0.06]=0
col=np.clip(B/np.maximum(a[...,None],1e-3),0,255); rgba=np.dstack([col,a*255]).astype(np.uint8)
m=a>0.25; lab,n=ndimage.label(ndimage.binary_dilation(m,iterations=int(sys.argv[5]) if len(sys.argv)>5 else 14)); objs=ndimage.find_objects(lab)
sz=ndimage.sum(m,lab,range(1,n+1)); keep=[i for i in range(n) if sz[i]>sz.max()*0.05]
boxes=[objs[i] for i in keep]
cents=[((b[0].start+b[0].stop)/2,(b[1].start+b[1].stop)/2,b) for b in boxes]
# 分行：按 y 聚類
cents.sort(key=lambda c:c[0]); rows=[]
for c in cents:
    if rows and abs(rows[-1][-1][0]-c[0])<120: rows[-1].append(c)
    else: rows.append([c])
order=[c for r in rows for c in sorted(r,key=lambda c:c[1])]
print('found',len(order))
for nm,(cy,cx,b) in zip(names,order):
    if nm=='-': continue
    y0,y1,x0,x1=b[0].start,b[0].stop,b[1].start,b[1].stop
    sub=rgba[y0:y1,x0:x1].copy(); lab2=lab[y0:y1,x0:x1]; idx=lab[int(cy),int(cx)] or np.bincount(lab2[lab2>0]).argmax()
    sub[lab2!=np.bincount(lab2[lab2>0].ravel()).argmax(),3]=0
    im=Image.fromarray(sub); bb=im.getbbox(); im=im.crop(bb)
    if im.height>h: im=im.resize((round(im.width*h/im.height),h),Image.LANCZOS)
    im.save(f'/home/claude/gb/art/patrol/{nm}.png'); print(nm,im.size)
