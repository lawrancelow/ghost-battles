# 左右補畫拼接：用重疊區模板匹配對位，羽化融合
import cv2, numpy as np
D='/home/claude/art/steam/'
W=cv2.imread(D+'wide1024.png'); L=cv2.imread(D+'left_ext_0_768.png'); R=cv2.imread(D+'right_ext_768_1536.png')
H=1024
# 左：L 嘅 x 650..768（原圖部分，canvas 636 起）喺 W 搵
tplL=L[200:900, 660:760]
r=cv2.matchTemplate(W[:, :300], tplL, cv2.TM_CCOEFF_NORMED); _,mv,_,ml=cv2.minMaxLoc(r)
dxL=ml[0]-660; dyL=ml[1]-200; print('left match',mv,dxL,dyL)
# 右：R 嘅 x 0..120（對應 canvas 768..888，屬原圖 W 尾 900 px → W x = W.w-900+768+..）
tplR=R[200:900, 10:110]
r=cv2.matchTemplate(W[:, -400:], tplR, cv2.TM_CCOEFF_NORMED); _,mv2,_,ml2=cv2.minMaxLoc(r)
xR=W.shape[1]-400+ml2[0]-10; dyR=ml2[1]-200; print('right match',mv2,xR,dyR)
# 畫布：左延伸 offset
offL=-dxL   # L 嘅 x=0 喺 W 座標 = dxL（負數）
left_w=offL; total=left_w+W.shape[1]+(R.shape[1]-(W.shape[1]-xR))
C=np.zeros((H,total,3),np.float32); A=np.zeros((H,total,1),np.float32)
def put(img,x,y,feather_l=0,feather_r=0):
    h,w=img.shape[:2]; m=np.ones((h,w,1),np.float32)
    if feather_l: m[:,:feather_l,0]*=np.linspace(0,1,feather_l)[None,:]
    if feather_r: m[:,w-feather_r:,0]*=np.linspace(1,0,feather_r)[None,:]
    ys,ye=max(y,0),min(y+h,H); sy=ys-y
    C[ys:ye,x:x+w]+=img[sy:sy+ye-ys].astype(np.float32)*m[sy:sy+ye-ys]; A[ys:ye,x:x+w]+=m[sy:sy+ye-ys]
# 先放原圖（中），左右延伸各重疊區羽化
ov=100
put(W,left_w,0,feather_l=ov,feather_r=ov)
put(L[:, :768],0,dyL*-1 if False else -dyL,feather_r=ov) if False else None
# L：只用到重疊區尾（x<= 768），佢喺畫布 x 0..768，W 由 left_w 開始，重疊 = 768-left_w
put(L,0,-dyL,feather_r=768-left_w)
put(R,left_w+xR,-dyR,feather_l=W.shape[1]-xR)
out=(C/np.maximum(A,1e-6)).clip(0,255).astype(np.uint8)
cv2.imwrite(D+'pano.png',out); print(out.shape, 'left_w',left_w)
