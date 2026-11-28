# usage: layers.py full.jpg bg.jpg outdir [min_area] [thr] [names comma]
import sys,os,json,cv2,numpy as np
full,bgp,out=sys.argv[1:4]
minA=int(sys.argv[4]) if len(sys.argv)>4 else 1500
thr=float(sys.argv[5]) if len(sys.argv)>5 else 40
names=sys.argv[6].split(',') if len(sys.argv)>6 else []
os.makedirs(out,exist_ok=True)
A=cv2.imread(full);B=cv2.imread(bgp)
if B.shape!=A.shape: B=cv2.resize(B,(A.shape[1],A.shape[0]),interpolation=cv2.INTER_AREA)
fa=cv2.GaussianBlur(A,(0,0),3).astype(np.float32);fb=cv2.GaussianBlur(B,(0,0),3).astype(np.float32)
d=np.abs(fa-fb).max(2)
d=cv2.GaussianBlur(d,(0,0),4)
m=(d>thr).astype(np.uint8)
m=cv2.morphologyEx(m,cv2.MORPH_OPEN,np.ones((5,5),np.uint8))
m=cv2.morphologyEx(m,cv2.MORPH_CLOSE,np.ones((15,15),np.uint8))
n,lab,st,cen=cv2.connectedComponentsWithStats(m)
comps=[i for i in range(1,n) if st[i,4]>=minA]
comps.sort(key=lambda i:(st[i,1],st[i,0]))
H,W=A.shape[:2];layers=[];prev=np.zeros((H,W),np.uint8)
cv2.imwrite(os.path.join(out,'bg.png'),B)
for k,i in enumerate(comps):
    x,y,w,h=st[i,:4];pad=int(max(w,h)*0.25)+8
    x0,y0=max(0,x-pad),max(0,y-pad);x1,y1=min(W,x+w+pad),min(H,y+h+pad)
    sub=A[y0:y1,x0:x1];cm=(lab[y0:y1,x0:x1]==i).astype(np.uint8)
    gm=np.full(cm.shape,cv2.GC_BGD,np.uint8)
    gm[cv2.dilate(cm,np.ones((25,25),np.uint8))>0]=cv2.GC_PR_BGD
    gm[cm>0]=cv2.GC_PR_FGD
    core=cv2.erode(cm,np.ones((9,9),np.uint8)); dc=(d[y0:y1,x0:x1]>thr*1.8)&(core>0)
    gm[dc]=cv2.GC_FGD
    bgd=np.zeros((1,65),np.float64);fgd=np.zeros((1,65),np.float64)
    try: cv2.grabCut(sub,gm,None,bgd,fgd,6,cv2.GC_INIT_WITH_MASK)
    except Exception as e: pass
    fg=((gm==cv2.GC_FGD)|(gm==cv2.GC_PR_FGD)).astype(np.uint8)
    nn,ll,ss,_=cv2.connectedComponentsWithStats(fg)
    if nn>1:
        big=1+np.argmax(ss[1:,4]); keep=np.zeros_like(fg)
        for j in range(1,nn):
            if ss[j,4]>=0.08*ss[big,4]: keep[ll==j]=1
        fg=keep
    fg=cv2.morphologyEx(fg,cv2.MORPH_CLOSE,np.ones((5,5),np.uint8))
    # fill holes
    ff=fg.copy();hmask=np.zeros((fg.shape[0]+2,fg.shape[1]+2),np.uint8);cv2.floodFill(ff,hmask,(0,0),1);fg=fg|(1-ff)
    al=cv2.GaussianBlur(fg.astype(np.float32),(0,0),0.8)
    ys,xs=np.where(fg>0)
    if len(xs)==0: continue
    bx0,bx1,by0,by1=xs.min(),xs.max()+1,ys.min(),ys.max()+1
    rgba=np.dstack([sub,(al*255).astype(np.uint8)])[by0:by1,bx0:bx1]
    nm=names[k] if k<len(names) else f'char{k+1}'
    cv2.imwrite(os.path.join(out,nm+'.png'),rgba)
    layers.append(dict(name=nm,file=nm+'.png',x=int(x0+bx0),y=int(y0+by0),w=int(bx1-bx0),h=int(by1-by0),scale=1.0,z=10+k,anchor='top-left'))
layers.sort(key=lambda L:L['y']+L['h'])
for z,L in enumerate(layers): L['z']=10+z
json.dump(dict(canvas=[W,H],source=os.path.basename(full),layers=[dict(name='bg',file='bg.png',x=0,y=0,w=W,h=H,scale=1.0,z=0)]+layers,
  note='座標以 canvas 像素計，左上為原點；z 越大越在上層；角色 PNG 已含透明邊緣'),open(os.path.join(out,'layout.json'),'w'),ensure_ascii=False,indent=1)
# preview: composite + boxes
comp=B.copy()
for L in layers:
    im=cv2.imread(os.path.join(out,L['file']),cv2.IMREAD_UNCHANGED);a=im[:,:,3:4]/255.0
    r=comp[L['y']:L['y']+L['h'],L['x']:L['x']+L['w']];r[:]=(im[:,:,:3]*a+r*(1-a)).astype(np.uint8)
dbg=comp.copy()
for L in layers: cv2.rectangle(dbg,(L['x'],L['y']),(L['x']+L['w'],L['y']+L['h']),(0,255,255),2);cv2.putText(dbg,L['name'],(L['x'],L['y']-4),0,0.6,(0,255,255),2)
cv2.imwrite(os.path.join(out,'_recomposite.jpg'),comp);cv2.imwrite(os.path.join(out,'_boxes.jpg'),dbg)
print(len(layers),[ (L['name'],L['x'],L['y'],L['w'],L['h']) for L in layers])
