# 假透明（格仔底）：由邊緣灌水，淺灰低飽和＝背景
import sys, numpy as np
from PIL import Image
from scipy import ndimage
im=np.array(Image.open(sys.argv[1]).convert('RGB')).astype(float); names=sys.argv[2].split(','); h=int(sys.argv[3])
mx=im.max(2); mn=im.min(2); bgc=(mn>175)&(mx-mn<22)
lab,n=ndimage.label(bgc); border=set(np.unique(np.r_[lab[0],lab[-1],lab[:,0],lab[:,-1]]))-{0}
bg=np.isin(lab,list(border))
bg=ndimage.binary_opening(bg,iterations=1)
fg=~bg; fg=ndimage.binary_fill_holes(fg)
# 內部大片格仔（物件之間）都要清：細格以外嘅大塊淺灰
inner=bgc&~bg; lab2,n2=ndimage.label(inner); s=ndimage.sum(inner,lab2,range(1,n2+1))
for i,v in enumerate(s):
    if v>50: fg[lab2==i+1]=False
a=ndimage.gaussian_filter(fg.astype(float),0.7)
rgba=np.dstack([im,a*255]).astype(np.uint8)
m=fg; labo,no=ndimage.label(ndimage.binary_dilation(m,iterations=6)); objs=ndimage.find_objects(labo)
sz=ndimage.sum(m,labo,range(1,no+1)); keep=[i for i in range(no) if sz[i]>sz.max()*0.05]
c=[((objs[i][0].start+objs[i][0].stop)/2,(objs[i][1].start+objs[i][1].stop)/2,i) for i in keep]
c.sort(key=lambda t:t[0]); rows=[]
for t in c:
    if rows and abs(rows[-1][-1][0]-t[0])<150: rows[-1].append(t)
    else: rows.append([t])
order=[t for r in rows for t in sorted(r,key=lambda t:t[1])]; print('found',len(order))
for nm,(cy,cx,i) in zip(names,order):
    b=objs[i]; sub=rgba[b].copy(); sub[labo[b]!=i+1,3]=0
    o=Image.fromarray(sub); o=o.crop(o.getbbox())
    if o.height>h: o=o.resize((round(o.width*h/o.height),h),Image.LANCZOS)
    o.save(f'/home/claude/gb/art/patrol/{nm}.png'); print(nm,o.size)
