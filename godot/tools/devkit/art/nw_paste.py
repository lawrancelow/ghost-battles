# nw_paste.py <key> <生成圖> [thr=40] [dil=6] [x0,y0,x1,y1]：軍團空手圖——只取兵器區域（對位後差異大＋boxes 限制框）貼返原圖，其餘像素＝原圖；遮罩區用 rembg＋白→透明（同 cutout_white.py）去背；工作資料夾 /home/claude/art/nw_lg（in/ meta.json boxes.json）
import sys, json, numpy as np, cv2
from PIL import Image
from scipy import ndimage as ndi
sys.path.insert(0, '/home/claude/wt/p44/godot/tools/devkit/art')
R='/home/claude/art/nw_lg'   # in/<k>.png（1024 白底輸入）、meta.json（縮放位置）、boxes.json（兵器限制框，原圖座標）
k=sys.argv[1]; cap=sys.argv[2]
thr=float(sys.argv[3]) if len(sys.argv)>3 else 40; dil=int(sys.argv[4]) if len(sys.argv)>4 else 6
meta=json.load(open(R+'/meta.json'))[k]; w,h,s,ox,oy=meta
C=np.asarray(Image.open(cap).convert('RGB'))
# 圖：css 820/866 of capture
px=round(C.shape[0]*820/866) if C.shape[:2]==(1092,1092) else min(C.shape[:2])   # 截圖（820/866）或者下載原檔（整張）
G=cv2.resize(C[:px,:px],(1024,1024),interpolation=cv2.INTER_AREA).astype(np.float32)
I=np.asarray(Image.open(f'{R}/in/{k}.png').convert('RGB')).astype(np.float32)
# 對位：ECC affine（灰度，模糊）
gi=cv2.GaussianBlur(cv2.cvtColor(I,cv2.COLOR_RGB2GRAY),(0,0),2); gg=cv2.GaussianBlur(cv2.cvtColor(G,cv2.COLOR_RGB2GRAY),(0,0),2)
War=np.eye(2,3,dtype=np.float32)
try:
    _,War=cv2.findTransformECC(gi/255,gg/255,War,cv2.MOTION_AFFINE,(cv2.TERM_CRITERIA_EPS|cv2.TERM_CRITERIA_COUNT,300,1e-6),None,5)
except Exception as e: print('ecc fail',e)
Ga=cv2.warpAffine(G,War,(1024,1024),flags=cv2.INTER_LINEAR+cv2.WARP_INVERSE_MAP,borderValue=(255,255,255))
# 兵器區：模糊差異大
d=np.abs(cv2.GaussianBlur(Ga,(0,0),3)-cv2.GaussianBlur(I,(0,0),3)).max(axis=2)
m=d>thr
m=ndi.binary_opening(m,iterations=2)
lab,n=ndi.label(m); 
if n:
    sz=ndi.sum(m,lab,range(1,n+1)); keep=[i+1 for i,v in enumerate(sz) if v>=400]
    m=np.isin(lab,keep)
BX=json.load(open(R+'/boxes.json'))
if len(sys.argv)>5 or k in BX:   # 限制框（原圖座標 x0,y0,x1,y1；預設 boxes.json）
    x0,y0,x1,y1=[float(v) for v in sys.argv[5].split(',')] if len(sys.argv)>5 else BX[k]
    box=np.zeros_like(m); box[int(oy+y0*s):int(oy+y1*s),int(ox+x0*s):int(ox+x1*s)]=True; m&=box
m=ndi.binary_fill_holes(ndi.binary_closing(m,iterations=6))
m=ndi.binary_dilation(m,iterations=dil*2)
mf=np.clip(cv2.GaussianBlur(m.astype(np.float32),(0,0),3)*1.0,0,1)[...,None]
O=I*(1-mf)+Ga*mf
# 原尺寸
def down(a): return cv2.resize(a[oy:oy+round(h*s),ox:ox+round(w*s)],(w,h),interpolation=cv2.INTER_AREA)
Os=down(O); Ms=np.clip(down(mf[...,0]),0,1)
orig=np.asarray(Image.open(f'/home/claude/wt/p44/godot/assets/spr/lg_{k}.webp').convert('RGBA')).astype(np.float32)
# 新 alpha（遮罩區）：rembg＋白→透明
from rembg import new_session, remove
rm=np.asarray(remove(Image.fromarray(Os.astype(np.uint8)),session=new_session('isnet-general-use'),only_mask=True)).astype(np.float32)/255
a2=np.clip((255-Os.min(axis=2))/255,0,1); a2=np.clip((a2-0.035)/0.965,0,1)
core=ndi.binary_erosion(rm>0.5,iterations=1)
an=np.where(core,1.0,a2*(rm>0.05))
A=orig[...,3]/255*(1-Ms)+an*Ms
# 顏色：遮罩區去白污染；其餘用原色
aa=np.maximum(an,1e-3)[...,None]; dec=np.clip((Os-255*(1-aa))/aa,0,255); newc=np.where(core[...,None],Os,dec)
col=orig[...,:3]*(1-Ms[...,None])+newc*Ms[...,None]
# 原 alpha 為 0 且新區唔受影響 → 保持
A[A<0.03]=0
out=Image.fromarray(np.dstack([col,A*255]).clip(0,255).astype(np.uint8),'RGBA')
out.save(f'/home/claude/art/out/NoWeapon/HC_lg_{k}_NoWeapon.png')
Image.fromarray((Ms*255).astype(np.uint8)).save(f'{R}/res/{k}_mask.png')
# 檢查圖：原｜遮罩｜成品（灰底）
def ongray(im):
    b=Image.new('RGBA',im.size,(150,150,150,255)); b.alpha_composite(im); return b.convert('RGB')
o0=Image.fromarray(orig.astype(np.uint8),'RGBA')
V=Image.new('RGB',(w*3+20,h),(255,255,255)); V.paste(ongray(o0),(0,0)); 
mv=ongray(o0).copy(); mm=Image.fromarray((Ms*160).astype(np.uint8)); red=Image.new('RGB',(w,h),(255,0,0)); mv.paste(red,(0,0),mm)
V.paste(mv,(w+10,0)); V.paste(ongray(out),(2*w+20,0)); V.save(f'{R}/res/{k}_view.png')
print(k,'ecc',np.round(War,3).tolist(),'mask%',round(float(Ms.mean())*100,1))
