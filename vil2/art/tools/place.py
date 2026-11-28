# place.py full.jpg bg.jpg sheet.png outdir spec.json
# spec: {"chars":[{"name":..,"hint":[x,y,w,h] (region in full where it sits),"pick":[cx,cy] point in sheet inside the component, "cut":[x0,y0,x1,y1] optional sheet-rect to erase}],"min_area":..}
import sys,os,json,cv2,numpy as np
full,bgp,sheetp,out,specp=sys.argv[1:6]
spec=json.load(open(specp));os.makedirs(out,exist_ok=True)
A=cv2.imread(full);B=cv2.imread(bgp)
if B.shape!=A.shape:B=cv2.resize(B,(A.shape[1],A.shape[0]),interpolation=cv2.INTER_AREA)
S=cv2.imread(sheetp,cv2.IMREAD_UNCHANGED)
al=S[:,:,3];bm=(al>40).astype(np.uint8)
bm2=cv2.dilate(bm,np.ones((spec.get('join',9),)*2,np.uint8))
n,lab,st,_=cv2.connectedComponentsWithStats(bm2)
H,W=A.shape[:2];layers=[]
gA=cv2.cvtColor(A,cv2.COLOR_BGR2GRAY).astype(np.float32)
for c in spec['chars']:
    px,py=c['pick'];i=lab[py,px]
    if i==0: print('pick miss',c['name']);continue
    m=((lab==i)&(bm>0)).astype(np.uint8)
    if 'clip' in c:
        cl=c['clip'];mm=np.zeros_like(m);mm[cl[1]:cl[3],cl[0]:cl[2]]=1;m=m*mm
    for cut in c.get('cut',[]): m[cut[1]:cut[3],cut[0]:cut[2]]=0
    for ext in c.get('add',[]):
        j=lab[ext[1],ext[0]]; m|=((lab==j)&(bm>0)).astype(np.uint8)
    nn,ll,ss,_=cv2.connectedComponentsWithStats(m)
    if nn>2:
        mx=ss[1:,4].max();m=np.isin(ll,[j for j in range(1,nn) if ss[j,4]>=0.03*mx]).astype(np.uint8)
    ys,xs=np.where(m>0);x0,x1,y0,y1=xs.min(),xs.max()+1,ys.min(),ys.max()+1
    T=S[y0:y1,x0:x1].copy();T[:,:,3]=(T[:,:,3]*m[y0:y1,x0:x1]).astype(np.uint8)
    hx,hy,hw,hh=c['hint'];best=None
    gT0=cv2.cvtColor(T[:,:,:3],cv2.COLOR_BGR2GRAY).astype(np.float32);mk0=(T[:,:,3]>128).astype(np.float32)
    for sc in np.linspace(c.get('smin',0.15),c.get('smax',0.9),60):
        tw,th=int(T.shape[1]*sc),int(T.shape[0]*sc)
        if tw<12 or th<12: continue
        pad=int(max(tw,th)*0.6)
        rx0,ry0=max(0,hx-pad),max(0,hy-pad);rx1,ry1=min(W,hx+hw+pad),min(H,hy+hh+pad)
        R=gA[ry0:ry1,rx0:rx1]
        if R.shape[0]<th or R.shape[1]<tw: continue
        gT=cv2.resize(gT0,(tw,th),interpolation=cv2.INTER_AREA);mk=cv2.resize(mk0,(tw,th),interpolation=cv2.INTER_NEAREST)
        r=cv2.matchTemplate(R,gT,cv2.TM_CCORR_NORMED,mask=mk)
        r=np.nan_to_num(r,nan=-1,posinf=-1,neginf=-1)
        _,v,_,loc=cv2.minMaxLoc(r)
        if best is None or v>best[0]: best=(v,sc,rx0+loc[0],ry0+loc[1],tw,th)
    v,sc,x,y,tw,th=best
    Ti=cv2.resize(T,(tw,th),interpolation=cv2.INTER_AREA)
    cv2.imwrite(os.path.join(out,c['name']+'.png'),T)  # full-res sprite
    layers.append(dict(name=c['name'],file=c['name']+'.png',x=int(x),y=int(y),w=tw,h=th,scale=round(float(sc),4),src_size=[int(T.shape[1]),int(T.shape[0])],match=round(float(v),3)))
    print(c['name'],'score',round(v,3),'scale',round(sc,3),'at',x,y,tw,th)
layers.sort(key=lambda L:L['y']+L['h'])
for z,L in enumerate(layers):L['z']=10+z
cv2.imwrite(os.path.join(out,'bg.png'),B)
json.dump(dict(canvas=[W,H],full=os.path.basename(full),layers=[dict(name='bg',file='bg.png',x=0,y=0,w=W,h=H,scale=1.0,z=0)]+layers,
 note='canvas 像素座標、左上原點。角色 PNG 為高解析原尺寸 src_size，放到畫面時縮放 scale 後置於 (x,y)，顯示尺寸 w×h。z 越大越上層。'),open(os.path.join(out,'layout.json'),'w'),ensure_ascii=False,indent=1)
comp=B.copy()
for L in layers:
    im=cv2.resize(cv2.imread(os.path.join(out,L['file']),cv2.IMREAD_UNCHANGED),(L['w'],L['h']),interpolation=cv2.INTER_AREA)
    x,y=L['x'],L['y'];x1,y1=min(W,x+L['w']),min(H,y+L['h']);im=im[:y1-y,:x1-x];a=im[:,:,3:4]/255.
    r=comp[y:y1,x:x1];r[:]=(im[:,:,:3]*a+r*(1-a)).astype(np.uint8)
cv2.imwrite(os.path.join(out,'_recomposite.jpg'),comp)
side=np.hstack([A,comp]);cv2.imwrite(os.path.join(out,'_compare.jpg'),cv2.resize(side,(side.shape[1]//2,side.shape[0]//2)))
