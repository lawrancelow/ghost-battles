import sys, json, numpy as np, cv2
sys.path.insert(0,'/home/claude/layerwork'); import lama
from scipy import ndimage as ndi
src, md, out, tag = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
img=cv2.imread(src); H,W=img.shape[:2]
def ld(n):
    m=np.load(f'{md}/s_{n}.npy').astype(bool)
    lab,k=ndi.label(m)
    if k>1:
        s=ndi.sum(m,lab,range(1,k+1)); m=np.isin(lab,[i+1 for i,v in enumerate(s) if v>=0.05*s.max()])
    hol=ndi.binary_fill_holes(m)&~m; hl,hk=ndi.label(hol)
    for i in range(1,hk+1):
        if (hl==i).sum()<0.02*m.sum(): m[hl==i]=True
    # grow: include thin dark strands (hair wisps) hugging the mask
    hsv=cv2.cvtColor(img,cv2.COLOR_BGR2HSV); V=hsv[...,2].astype(np.float32)
    med=cv2.medianBlur(V.astype(np.uint8),21).astype(np.float32)
    ring=(cv2.dilate(m.astype(np.uint8),np.ones((31,31),np.uint8))>0)&~m
    dark=ring&(V<med-28)
    lab,k=ndi.label(dark|m)
    keep=np.unique(lab[m]); g=np.isin(lab,keep[keep>0])
    return m|g
groups={'L3_male':['male'],'L3_female':['female'],'L2_ceiling_left':['ceilL'],'L2_ceiling_right':['ceilR'],
 'L1_ghosts_left':['oni','hats','granny'],'L1_ghosts_right':['ox','horse','flower','lion','longhair']}
import os
if os.path.exists(f'{md}/s_grannyorn.npy'): groups['L1_ghosts_left'].append('grannyorn')
M={g:np.any([ld(n) for n in ns],axis=0) for g,ns in groups.items()}
front=M['L3_male']|M['L3_female']
for g in ['L1_ghosts_left','L1_ghosts_right','L2_ceiling_left','L2_ceiling_right']: M[g]&=~front
M['L3_female']&=~M['L3_male'] if False else M['L3_female']
allm=np.any(list(M.values()),axis=0)
K=lambda r: np.ones((2*r+1,2*r+1),np.uint8)
hole=cv2.dilate(allm.astype(np.uint8),K(13))>0
bgi=lama.inpaint_tiled(img,hole)
keep=cv2.dilate(allm.astype(np.uint8),K(2))>0
bg=img.copy(); bg[keep]=bgi[keep]
for g in M: M[g]=cv2.dilate(M[g].astype(np.uint8),K(2))>0
def rgba(rgb,mask):
    a=cv2.GaussianBlur(mask.astype(np.float32),(0,0),0.8); a[mask]=1.0
    return np.dstack([rgb,(a*255).astype(np.uint8)])
cv2.imwrite(f'{out}/L0_background.png',bg)
meta={'size':[W,H],'layers':[]}
order=['L0_background','L1_ghosts_left','L1_ghosts_right','L2_ceiling_left','L2_ceiling_right','L3_male','L3_female']
par={'L0_background':0.10,'L1_ghosts_left':0.16,'L1_ghosts_right':0.16,'L2_ceiling_left':0.22,'L2_ceiling_right':0.22,'L3_male':0.38,'L3_female':0.38}
for g in order[1:]:
    cv2.imwrite(f'{out}/{g}.png',rgba(img,M[g]))
for i,g in enumerate(order):
    e={'file':f'{g}.png','z':i,'parallax':par[g]}
    if g!='L0_background':
        ys,xs=np.where(M[g]); e['bbox']=[int(xs.min()),int(ys.min()),int(xs.max()-xs.min()+1),int(ys.max()-ys.min()+1)]
        if g.startswith('L2'):
            top=ys.min(); xt=xs[ys<=top+6]; e['anim']='sway'; e['anchor']=[int(xt.mean()),int(top)]; e['note']='繞錨點緩慢擺動，建議 ±2.5°、週期 5–7 秒'
        elif g.startswith('L3'):
            e['anim']='float_breathe'; e['anchor']=[int((xs.min()+xs.max())/2),int(ys.max())]; e['note']='上下漂浮 ±4px（週期約 3 秒）＋胸口呼吸縮放 1.0–1.015；男女主錯開相位'
        else:
            e['anim']='idle'; e['note']='下半身被隔板擋住，只做極小位移（≤3px）或輕微明暗變化，否則切口會露出'
    else: e['note']='底圖；角色後方已用 LaMa 補畫'
    meta['layers'].append(e)
# glow masks
hsv=cv2.cvtColor(img,cv2.COLOR_BGR2HSV); Hh,S,V=hsv[...,0].astype(int),hsv[...,1]/255.,hsv[...,2].astype(int)
notc=~cv2.dilate(allm.astype(np.uint8),np.ones((5,5)))>0
def soft(m,d=5,b=4):
    m=ndi.binary_opening(m,iterations=1); lab,k=ndi.label(m)
    if k: 
        s=ndi.sum(m,lab,range(1,k+1)); m=np.isin(lab,[i+1 for i,v in enumerate(s) if v>=40])
    m=cv2.dilate(m.astype(np.uint8)*255,np.ones((d,d),np.uint8)); return cv2.GaussianBlur(m,(0,0),b)
glows={
 'glow_lights':(V>200)&(S<0.42)&(Hh>=15)&(Hh<=45),
 'glow_monitors':(V>140)&(S>0.18)&(Hh>=38)&(Hh<=80),
 'glow_lamps':(V>205)&(S>0.42)&(Hh>=12)&(Hh<=30),
 'glow_moon':(V>120)&(S>0.45)&((Hh<=8)|(Hh>=170))}
ROI={'portrait':{'glow_lights':[(0,0,W,340)],'glow_lamps':[(225,640,90,80),(380,615,40,40),(465,590,35,30),(595,595,30,30)],'glow_monitors':[(0,560,W,240)],'glow_moon':[(380,380,300,150)]},
     'wide':{'glow_lights':[(0,0,W,255)],'glow_lamps':[(455,505,100,70),(735,430,60,45),(1070,355,40,30)],'glow_monitors':[(560,320,700,300)],'glow_moon':[(860,170,220,150)]}}[tag]
def roi(k):
    r=np.zeros((H,W),bool)
    for x,y,w,h in ROI[k]: r[y:y+h,x:x+w]=True
    return r
for k,m in glows.items():
    m=m&notc&roi(k)
    if k=='glow_moon':
        lab,n=ndi.label(m); s=ndi.sum(m,lab,range(1,n+1)); m=lab==(np.argmax(s)+1)
        m=ndi.binary_fill_holes(m)
    g=soft(m); cv2.imwrite(f'{out}/{k}.png',g)
    meta.setdefault('glow',[]).append({'file':f'{k}.png','note':{'glow_lights':'日光燈：偶爾閃一下（加亮或短暫變暗）','glow_monitors':'電腦螢幕：慢呼吸式明暗、偶爾雪花閃','glow_lamps':'檯燈：輕微暖光呼吸','glow_moon':'紅月：極慢的光暈脈動'}[k],'blend':'add（遮罩×原圖顏色疊加提亮）'})
json.dump(meta,open(f'{out}/layers.json','w'),ensure_ascii=False,indent=1)
# recomposite check
acc=bg.astype(np.float32)
for g in order[1:]:
    L=cv2.imread(f'{out}/{g}.png',cv2.IMREAD_UNCHANGED).astype(np.float32); a=L[...,3:]/255.
    acc=acc*(1-a)+L[...,:3]*a
d=np.abs(acc-img.astype(np.float32)).mean(axis=2)
print(tag,'mean diff',round(float(d.mean()),3),'max',round(float(d.max()),1),'px>8:',int((d>8).sum()))
cv2.imwrite(f'{out}/_recomp.png',acc.astype(np.uint8))
