import json, sys, numpy as np
from PIL import Image, ImageFilter, ImageDraw
D='/home/claude/ghost-battles/dev/art_wip_p17'; B=json.load(open(D+'/boxes.json'))
G='/home/claude/ghost-battles/godot/assets/img/'
def lum(im,n=48): return np.asarray(im.convert('L').resize((n,n)),float)
def corr(a,b): a=a-a.mean(); b=b-b.mean(); return float((a*b).sum()/np.sqrt((a*a).sum()*(b*b).sum()+1e-9))
rep={}
for n in [int(x) for x in __import__("os").environ.get("LV","2,3,4").split(",")]:
    orig=Image.open('/home/claude/out/z/zone%d_orig.png'%n).convert('RGB'); W,H=orig.size
    full=orig.copy()
    keys=[k for k in B if k.startswith('%d_'%n)]
    keys.sort(key=lambda k:(k.endswith('village'), 'market' in k))
    for k in keys:
        box=B[k]['box']; w,h=box[2]-box[0],box[3]-box[1]
        ref=orig.crop(box); p=Image.open('%s/%s.jpg'%(D,k)).convert('RGB')
        q=np.asarray(p).max(2); rr=np.where(q.mean(1)>18)[0]; cc=np.where(q.mean(0)>18)[0]   # 切走截圖留低嘅黑邊
        p=p.crop((int(cc[0]),int(rr[0]),int(cc[-1])+1,int(rr[-1])+1)).resize((w,h),Image.LANCZOS)
        c0=corr(lum(ref),lum(p)); c1=corr(lum(ref),lum(p.rotate(180)))
        if c1>c0+0.1: p=p.rotate(180)
        rep[k]=(round(c0,2),round(c1,2))
        # AI 自己畫嘅地圖外暗帶（同原圖位置有偏差）：用周圍地面補返
        import cv2
        pa=np.asarray(p); pm=pa.max(2).astype(np.uint8)
        lo=cv2.dilate(pm,np.ones((9,9),np.uint8))-cv2.erode(pm,np.ones((9,9),np.uint8))
        vm=((pm<30)&(lo<9)).astype(np.uint8)
        nl,lab,st,_=cv2.connectedComponentsWithStats(vm,8)
        keep=np.zeros_like(vm)
        for i in range(1,nl):
            if st[i,cv2.CC_STAT_AREA]>2500 and min(st[i,cv2.CC_STAT_WIDTH],st[i,cv2.CC_STAT_HEIGHT])>=12: keep[lab==i]=1
        keep=cv2.dilate(keep,np.ones((7,7),np.uint8))
        if keep.any():
            pa=cv2.inpaint(np.ascontiguousarray(pa[:,:,::-1]),keep*255,9,cv2.INPAINT_TELEA)[:,:,::-1]
            p=Image.fromarray(np.ascontiguousarray(pa))
        rep[k+'_void%']=round(float(keep.mean())*100,1)
        fe=14; m=Image.new('L',(w,h),0); ImageDraw.Draw(m).rectangle((fe*2,fe*2,w-fe*2-1,h-fe*2-1),fill=255); m=m.filter(ImageFilter.GaussianBlur(fe))
        full.paste(p,box[:2],m)
    # 地圖外嘅純暗區還原原圖（邊界保持筆直）
    o=np.asarray(orig,float); mx=o.max(2)
    loc=np.asarray(Image.fromarray(mx.astype(np.uint8)).filter(ImageFilter.MaxFilter(9)),float)-np.asarray(Image.fromarray(mx.astype(np.uint8)).filter(ImageFilter.MinFilter(9)),float)
    void=((mx<34)&(loc<10)).astype(np.uint8)*255
    void=Image.fromarray(void).filter(ImageFilter.MinFilter(5)).filter(ImageFilter.GaussianBlur(3))
    full.paste(orig,(0,0),void)
    full.save('/home/claude/out/z/zone%d_styleD.png'%n)
    full.crop((0,0,W,H//2)).save(G+'zone%d_ground_a.webp'%n,quality=90); full.crop((0,H//2,W,H)).save(G+'zone%d_ground_b.webp'%n,quality=90)
    c=Image.new('RGB',(W*2+30,H),(255,255,255)); c.paste(orig,(0,0)); c.paste(full,(W+30,0)); c.resize((c.width//6,c.height//6)).save('/tmp/bs/st%d.jpg'%n,quality=85)
    c.resize((c.width//2,c.height//2),Image.LANCZOS).save('/home/claude/out/GhostBattles_Zone%d_Ground_BeforeAfter.png'%n)
print(rep)
