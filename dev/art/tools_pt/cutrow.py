# 白底一排角色：連通塊（膨脹後）取最大 N 塊，左到右命名，存 art/patrol/<名>.png（高 h）
import sys, numpy as np
from PIL import Image
from scipy import ndimage
im=np.array(Image.open(sys.argv[1]).convert('RGB')).astype(float); names=sys.argv[2].split(','); h=int(sys.argv[3]); thr=int(sys.argv[4]) if len(sys.argv)>4 else 236
mn=im.min(2); bgc=mn>thr
lab,n=ndimage.label(bgc); border=set(np.unique(np.r_[lab[0],lab[-1],lab[:,0],lab[:,-1]]))-{0}
fg=~np.isin(lab,list(border))
fg=ndimage.binary_opening(fg,iterations=1)
blob,nb=ndimage.label(ndimage.binary_dilation(fg,iterations=14)); sz=ndimage.sum(fg,blob,range(1,nb+1))
top=sorted(np.argsort(sz)[::-1][:len(names)]+1, key=lambda b: np.where(blob==b)[1].mean())
# 柔邊：越近白越透明（淡色鬼保留半透明）
soft=np.clip((255-mn)/ (255-thr+18),0,1)
for nm,b in zip(names,top):
    keep=(blob==b)&fg; ys,xs=np.where(keep)
    a=ndimage.gaussian_filter(keep.astype(float),0.7)*np.maximum(soft,ndimage.binary_erosion(keep,iterations=3))
    sub=np.dstack([im,a*255])[ys.min():ys.max()+1, xs.min():xs.max()+1].astype(np.uint8)
    o=Image.fromarray(sub); o=o.resize((round(o.width*h/o.height),h),Image.LANCZOS); o.save(f'art/patrol/{nm}.png'); print(nm,o.size)
