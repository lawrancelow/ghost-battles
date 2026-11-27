import numpy as np, cv2
from PIL import Image
def brush(H, rot):
    raw=np.array(Image.open('/home/claude/art/title/btn/jiaban_brush_raw.png').convert('RGB')).astype(np.float32)
    ink=np.clip((255-raw[:,:,1])/255*1.25-0.08,0,1)*(raw[:,:,0]>120)
    ys,xs=np.where(ink>0.15); ink=ink[ys.min():ys.max()+1,xs.min():xs.max()+1]
    h,w=ink.shape; W=int(round(w*H/h)); m=cv2.resize(ink,(W,H),interpolation=cv2.INTER_AREA)
    M=cv2.getRotationMatrix2D((W/2,H/2),rot,1.0); c,s=abs(M[0,0]),abs(M[0,1]); nW,nH=int(H*s+W*c)+2,int(H*c+W*s)+2
    M[0,2]+=nW/2-W/2; M[1,2]+=nH/2-H/2; return cv2.warpAffine(m,M,(nW,nH))
def tag_ink(src,dst,rot,hfrac=0.72):
    a=np.array(Image.open(src).convert('RGBA')); rgb=a[:,:,:3].astype(np.float32)
    yel=((rgb[:,:,0]>190)&(rgb[:,:,1]>150)&(rgb[:,:,2]<150)&(a[:,:,3]>200)).astype(np.uint8)
    n,l,st,ct=cv2.connectedComponentsWithStats(yel,8)
    i=1+np.argmax(st[1:,4]); x,y,w,h,_=st[i]; cx,cy=ct[i]
    tag=(l==i).astype(np.uint8); tag=cv2.morphologyEx(tag,cv2.MORPH_CLOSE,np.ones((9,9),np.uint8))
    tag=cv2.erode(tag,np.ones((5,5),np.uint8)).astype(np.float32)
    m=brush(int(h*hfrac),rot); hh,ww=m.shape
    full=np.zeros(tag.shape,np.float32); Y0=int(cy-hh/2+h*0.03); X0=int(cx-ww/2)
    ys,xs=max(0,Y0),max(0,X0); full[ys:Y0+hh,xs:X0+ww]=m[ys-Y0:,xs-X0:][:full.shape[0]-ys,:full.shape[1]-xs]
    full*=cv2.GaussianBlur(tag,(0,0),1.2)
    o=rgb*(1-full[...,None]*0.95)+np.array([165,26,18],np.float32)*full[...,None]*0.95
    a[:,:,:3]=np.clip(o,0,255).astype(np.uint8); Image.fromarray(a).save(dst); print(dst,(x,y,w,h))
tag_ink('btn_main_plate.png','btn_main.png',-12,0.62)
tag_ink('btn_sub_plate.png','btn_sub.png',-12,0.66)
