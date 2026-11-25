import numpy as np, math, random
from PIL import Image, ImageDraw, ImageFilter
from scipy.ndimage import map_coordinates, binary_erosion
random.seed(5)
S=2                                      # 超取樣
src=Image.open('/tmp/pa/pole2.png').convert('RGBA')
LEN=600*S; TH=40*S; X0=24*S
src=np.array(src.resize((LEN,TH),Image.BICUBIC)).astype(float)
W=LEN+2*X0; H=150*S; ARC=10.0*S; CY=46*S
def yc(x):
    u=(x-X0)/LEN*2-1
    return CY+ARC*u*u
def th(x):
    u=abs((x-X0)/LEN*2-1)
    t=TH-TH*0.5*u**2.0
    if u>0.955: t*=max(0.08,1-(u-0.955)/0.045*0.9)
    return t
yy,xx=np.mgrid[0:H,0:W].astype(float)
T=np.vectorize(th)(np.arange(W)); C=np.vectorize(yc)(np.arange(W))
inside=(xx>=X0)&(xx<X0+LEN)
v=(yy-(C[None,:]-T[None,:]/2))/np.maximum(T[None,:],1)
mask=inside&(v>=0)&(v<=1)
sy=v*(TH-1); sx=(xx-X0)
out=np.zeros((H,W,4))
for ch in range(4):
    out[...,ch]=map_coordinates(src[...,ch],[np.clip(sy,0,TH-1),np.clip(sx,0,LEN-1)],order=1)
# 劈開竹凹槽：中間淺
k=1.0+0.15*np.exp(-((v-0.42)/0.22)**2)
out[...,:3]=np.clip(out[...,:3]*k[...,None],0,255)
out[...,3]=np.where(mask,255,0)
# 墨邊：遮罩邊緣 3px（S 倍）深啡墨，加少少抖
er=binary_erosion(mask,iterations=3*S)
edge=mask&~er
jit=np.random.rand(H,W)<0.12
ink=np.array([34,24,16])
out[edge,:3]=ink*0.95+out[edge,:3]*0.05
im=Image.fromarray(out.astype(np.uint8),'RGBA')
d=ImageDraw.Draw(im)
# 凹槽內緣淡墨線
pts=[(x,yc(x)-th(x)*0.1+random.uniform(-0.6,0.6)*S) for x in range(X0+40*S,X0+LEN-40*S,10*S)]
d.line(pts,fill=(70,50,28,110),width=2*S,joint='curve')
# 掛鈎＋綁繩
def hook(cx):
    c=yc(cx); t=th(cx); y0=c+t/2
    # 鐵鈎：由繩圈落嚟，鈎口向外
    d.line((cx,y0,cx,y0+28*S),fill=(24,20,22,255),width=4*S)
    d.arc((cx-16*S,y0+20*S,cx,y0+38*S),0,180,fill=(24,20,22,255),width=4*S)
    d.line((cx-16*S,y0+29*S,cx-14*S,y0+22*S),fill=(24,20,22,255),width=4*S)
    d.line((cx,y0+2*S,cx,y0+26*S),fill=(110,104,108,190),width=1*S)
    HK.append((cx-8*S,y0+38*S))
def rope(cx):
    c=yc(cx); t=th(cx)
    cols=[(84,70,78),(104,86,90),(70,58,62),(118,96,84)]
    for i in range(8):
        x=cx-14*S+i*4*S
        d.line((x-3*S,c-t/2-3*S,x+3*S,c+t/2+3*S),fill=(28,20,18,245),width=6*S)
        d.line((x-3*S,c-t/2-3*S,x+3*S,c+t/2+3*S),fill=cols[i%4]+(255,),width=3*S)
    # 吊落去嘅繩尾
    d.line((cx+2*S,c+t/2,cx-2*S,c+t/2+10*S),fill=(70,58,62,255),width=3*S)
HK=[]
for u in [0.115,0.885]:
    cx=X0+u*LEN; hook(cx); rope(cx)
bb=im.getbbox(); im=im.crop(bb)
print('hooks', [((x-bb[0])/(bb[2]-bb[0]), (y-bb[1])/(bb[3]-bb[1])) for x,y in HK], 'shoulder_y', (yc(X0+LEN/2)-bb[1])/(bb[3]-bb[1]))
im=im.resize((im.width//S,im.height//S),Image.LANCZOS)
im.save('biandan.png'); print(im.size)
# 吊點（鈎底）喺圖入面嘅位置（比例），俾遊戲用
bb=None
