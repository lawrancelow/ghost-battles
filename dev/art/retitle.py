import cv2, numpy as np
from PIL import Image
im=cv2.cvtColor(np.array(Image.open('cut/cover.png').convert('RGB')),cv2.COLOR_RGB2BGR)
H,W=im.shape[:2]
band=im[0:330].astype(int); b,g,r=band[...,0],band[...,1],band[...,2]
lum=(r*3+g*6+b)/10
cream=(lum>165)&(r>b)
dark=(lum<95)&(r>b+5)
red=(r>150)&(g<110)&(b<120)
m=((cream|dark|red)*255).astype(np.uint8)
m[:, 990:]=0; m[:40]=0
# restrict to title zone
zone=np.zeros_like(m); zone[45:310,30:560]=255; zone[45:252,540:985]=255; zone[0:140,915:]=0; m&=zone
m=cv2.morphologyEx(m,cv2.MORPH_CLOSE,np.ones((9,9),np.uint8))
# keep big components
n,lab,st,_=cv2.connectedComponentsWithStats(m)
keep=np.zeros_like(m)
for i in range(1,n):
    if st[i,4]>1500: keep[lab==i]=255
# fill holes
ff=keep.copy(); h2=np.zeros((332,W+2),np.uint8); cv2.floodFill(ff,h2,(0,0),255)
keep|=cv2.bitwise_not(ff)
keep=cv2.dilate(keep,np.ones((5,5),np.uint8))
cv2.imwrite('/tmp/claude-0/mask.png',keep)
full=np.zeros((H,W),np.uint8); full[:330]=keep
np.save('/tmp/claude-0/mask.npy',full)
