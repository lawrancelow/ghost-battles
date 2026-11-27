# 用 ChatGPT 生成的真毛筆「加班」作字形遮罩，貼到黃牌上
import sys, numpy as np, cv2
from PIL import Image
src,dst,rot,ox,oy,H = sys.argv[1],sys.argv[2],float(sys.argv[3]),int(sys.argv[4]),int(sys.argv[5]),int(sys.argv[6])
raw=np.array(Image.open('jiaban_brush_raw.png').convert('RGB')).astype(np.float32)
# 紅墨濃度：1 - (G 通道/255)，白紙＝0
ink=np.clip((255-raw[:,:,1])/255*1.25-0.08,0,1)
ink[:, :] *= (raw[:,:,0]>120)   # 只取紅色
ys,xs=np.where(ink>0.15); ink=ink[ys.min():ys.max()+1, xs.min():xs.max()+1]
h,w=ink.shape; W=int(round(w*H/h))
m=cv2.resize(ink,(W,H),interpolation=cv2.INTER_AREA)
M=cv2.getRotationMatrix2D((W/2,H/2),rot,1.0)
c,s=abs(M[0,0]),abs(M[0,1]); nW,nH=int(H*s+W*c)+2,int(H*c+W*s)+2
M[0,2]+=nW/2-W/2; M[1,2]+=nH/2-H/2
m=cv2.warpAffine(m,M,(nW,nH))
# 原圖去舊字
im=Image.open(src).convert('RGBA'); a=np.array(im); rgb=a[:,:,:3].astype(int)
x0,y0,x1,y1=56,56,124,152
reg=rgb[y0:y1,x0:x1]; red=(reg[:,:,0]>140)&(reg[:,:,1]<120)&(reg[:,:,0]-reg[:,:,1]>60)
mask=np.zeros(rgb.shape[:2],np.uint8); mask[y0:y1,x0:x1][red]=255
mask=cv2.dilate(mask,np.ones((3,3),np.uint8),2)
fix=cv2.inpaint(cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2BGR),mask,5,cv2.INPAINT_TELEA)
yel=cv2.cvtColor(fix,cv2.COLOR_BGR2RGB).astype(np.float32)
noise=np.random.RandomState(3).normal(0,9,yel.shape[:2])[:,:,None]
yel=np.where((mask>0)[:,:,None],np.clip(yel+noise,0,255),yel)
# 只在黃牌範圍內上墨（牌外不畫），墨色：朱紅，深淺跟原筆觸
tag=(yel[:,:,0]>150)&(yel[:,:,1]>120)&(yel[:,:,2]<140)&(a[:,:,3]>200)
tag=cv2.erode(tag.astype(np.uint8),np.ones((3,3),np.uint8),1).astype(np.float32)
full=np.zeros(yel.shape[:2],np.float32)
hh,ww=m.shape; Y0,X0=oy-hh//2,ox-ww//2
full[Y0:Y0+hh,X0:X0+ww]=m
full*=cv2.GaussianBlur(tag,(0,0),1.0)
ink_col=np.array([165,26,18],np.float32)
o=yel*(1-full[:,:,None]*0.95)+ink_col*full[:,:,None]*0.95
out=a.copy(); out[:,:,:3]=np.clip(o,0,255).astype(np.uint8)
Image.fromarray(out).save(dst,'WEBP',quality=95,method=6)
Image.fromarray(out).crop((40,0,160,177)).resize((360,531)).save(dst+'.tag.png')
