# 白底切圖：由邊緣灌水（近白＝背景），按格（cols×rows）切，存 art/patrol/<名>.png
import sys, numpy as np
from PIL import Image
from scipy import ndimage
im=np.array(Image.open(sys.argv[1]).convert('RGB')).astype(float); names=sys.argv[2].split(','); h=int(sys.argv[3]); cols=int(sys.argv[4]); rows=int(sys.argv[5])
mn=im.min(2); bgc=mn>232
lab,n=ndimage.label(bgc); border=set(np.unique(np.r_[lab[0],lab[-1],lab[:,0],lab[:,-1]]))-{0}
bg=np.isin(lab,list(border))
fg=~bg
# 內部封閉白洞（細的）保留；大的白洞（例如把手中間）挖走
inner=bgc&~bg; lab2,n2=ndimage.label(inner); s=ndimage.sum(inner,lab2,range(1,n2+1))
for i,v in enumerate(s):
    if v>900: fg[lab2==i+1]=False
a=ndimage.gaussian_filter(fg.astype(float),0.6)
H,W=fg.shape; cw,ch=W/cols,H/rows
for i,nm in enumerate(names):
    if nm=='-': continue
    x0,y0=int((i%cols)*cw),int((i//cols)*ch); m=fg[y0:int(y0+ch),x0:int(x0+cw)]
    lab3,n3=ndimage.label(ndimage.binary_dilation(m,iterations=8)); sz=ndimage.sum(m,lab3,range(1,n3+1)); big=np.argmax(sz)+1
    keep=(lab3==big)&m; ys,xs=np.where(keep)
    sub=np.dstack([im[y0:int(y0+ch),x0:int(x0+cw)], a[y0:int(y0+ch),x0:int(x0+cw)]*255*keep])[ys.min():ys.max()+1, xs.min():xs.max()+1].astype(np.uint8)
    o=Image.fromarray(sub)
    if o.height>h: o=o.resize((round(o.width*h/o.height),h),Image.LANCZOS)
    o.save(f'/home/claude/gb/art/patrol/{nm}.png'); print(nm,o.size)
