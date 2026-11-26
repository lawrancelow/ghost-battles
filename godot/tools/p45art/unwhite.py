# 白底去背：由邊界 flood fill 近白色＝背景，邊緣軟化＋去白邊，出 512（物件 fit 470）
import sys, numpy as np
from PIL import Image
from scipy import ndimage
def cut(src, dst, thr=22):
    im=np.asarray(Image.open(src).convert('RGB')).astype(float)
    d=(255-im).max(2)
    cand=d<thr
    lab,n=ndimage.label(cand)
    border=set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]])))-{0}
    bg=np.isin(lab,list(border))
    # 灰影：低彩度、偏光、同背景相連 → 都當背景
    ch=im.max(2)-im.min(2); sh=(ch<14)&(im.min(2)>120)
    l3,_=ndimage.label(bg|sh); ids=set(np.unique(l3[bg]))-{0}; bg=np.isin(l3,list(ids))
    # 細孔：唔同邊界連通嘅白色唔去（瓷碗白底花紋要留）
    obj=~bg
    obj=ndimage.binary_opening(obj,iterations=1)
    lab2,n2=ndimage.label(obj); sz=ndimage.sum(obj,lab2,range(1,n2+1))
    keep=np.zeros(n2+1,bool); keep[1:]=sz>=0.002*obj.size; obj=keep[lab2]
    # 邊帶：物件外 2px 內用白度做 alpha
    near=ndimage.binary_dilation(obj,iterations=2)&~obj
    a=np.zeros(d.shape); a[obj]=1.0
    a[near]=np.clip((d[near]-6)/50,0,1)
    edge=ndimage.binary_dilation(~obj,iterations=1)&obj
    a[edge]=np.clip(np.maximum(d[edge]/60,0.35),0,1)
    aa=np.maximum(a,1e-3)[...,None]
    rgb=np.clip((im-(1-aa)*255)/aa,0,255)
    out=np.dstack([rgb,a*255]).astype(np.uint8)
    o=Image.fromarray(out,'RGBA'); ys,xs=np.where(a>0.05)
    o=o.crop((xs.min(),ys.min(),xs.max()+1,ys.max()+1))
    s=min(470/o.width,470/o.height); o=o.resize((round(o.width*s),round(o.height*s)),Image.LANCZOS)
    can=Image.new('RGBA',(512,512),(0,0,0,0)); can.paste(o,((512-o.width)//2,(512-o.height)//2),o); can.save(dst)
    print(dst,o.size)
if __name__=='__main__': cut(sys.argv[1],sys.argv[2])
