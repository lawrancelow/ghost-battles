import cv2, numpy as np, sys
from PIL import Image
src=Image.open('cut/cover.png').convert('RGB'); A=np.array(src)
M=np.load('/tmp/claude-0/mask.npy')
H,W=M.shape
# sky texture fill for old title
rng=np.random.default_rng(3); P=40
acc=np.zeros((330,W,3)); wsum=np.zeros((330,W,1))
g=cv2.getGaussianKernel(P,P/3); wk=(g@g.T)[...,None]; wk/=wk.max()
for y in range(-P//2,330,P//2):
  for x in range(-P//2,W,P//2):
    sy=rng.integers(2,42-P+40) if False else 2; sx=rng.integers(0,600-P)
    patch=A[2:2+P, sx:sx+P].astype(float)
    y0,x0=max(y,0),max(x,0); y1,x1=min(y+P,330),min(x+P,W)
    acc[y0:y1,x0:x1]+=patch[y0-y:y1-y,x0-x:x1-x]*wk[y0-y:y1-y,x0-x:x1-x]
    wsum[y0:y1,x0:x1]+=wk[y0-y:y1-y,x0-x:x1-x]
tile=(acc/np.maximum(wsum,1e-6)).astype(np.uint8)
fill=A.copy(); fill[:330]=tile
# smooth color drift: blend toward local column mean of rows 300-330 at bottom of band
ME=cv2.dilate(M,np.ones((15,15),np.uint8)); soft=cv2.GaussianBlur(ME.astype(np.float32)/255,(0,0),6)[...,None]
base=(A*(1-soft)+fill*soft).astype(np.uint8)
out=Image.fromarray(base).convert('RGBA')
ML=np.load('/tmp/claude-0/ml.npy'); MR=np.load('/tmp/claude-0/mr.npy')
def piece(x0,x1,y0,y1,MM):
    rgba=np.dstack([A[y0:y1,x0:x1],MM[y0:y1,x0:x1]])
    return Image.fromarray(rgba,'RGBA')
s1,s2=float(sys.argv[1]),float(sys.argv[2])
p1=piece(30,560,40,312,ML); p2=piece(500,990,40,256,MR)
p1=p1.resize((int(p1.width*s1),int(p1.height*s1)),Image.LANCZOS)
p2=p2.resize((int(p2.width*s2),int(p2.height*s2)),Image.LANCZOS)
x1,y1=int(sys.argv[3]),int(sys.argv[4]); x2,y2=int(sys.argv[5]),int(sys.argv[6])
# shadow
for p,(x,y) in ((p1,(x1,y1)),(p2,(x2,y2))):
    sh=Image.new('RGBA',p.size,(20,10,20,0)); a=np.array(p)[...,3]
    sh.putalpha(Image.fromarray((cv2.GaussianBlur(a,(0,0),6)*0.55).astype(np.uint8)))
    out.alpha_composite(sh,(x+5,y+8)); out.alpha_composite(p,(x,y))
out.convert('RGB').save('cut/cover_new.png')
out.convert('RGB').resize((341,512)).save('/tmp/claude-0/cnew.png')
