from PIL import Image, ImageFilter
import numpy as np
D='/tmp/claude-0/lay/'
P=Image.open(D+'office_pano.png').convert('RGBA'); H=1024; FLOOR=636
ch=np.asarray(P.crop((5860,0,5960,H)))
a=np.asarray(Image.open(D+'new_pano2.png').convert('RGBA')).copy(); orig=a.copy()
def fill(x0,x1,wallsrc=None):
    col=a[:,x1+1].copy(); top=0
    for y in range(60,FLOOR):
        if all(int(p[2])<=int(p[0]) for p in col[y:y+12]): top=y; break
    w=x1-x0; src=x1+1
    a[:top,x0:x1]=a[:top,src:src+w]; a[FLOOR-30:,x0:x1]=a[FLOOR-30:,src:src+w]
    for xx in range(x0,x1):
        a[top:FLOOR-30,xx]= ch[top:FLOOR-30,(xx-x0)%100] if wallsrc is None else orig[top:FLOOR-30,wallsrc[0]+(xx-x0)%(wallsrc[1]-wallsrc[0])]
fill(1616,1654,(1656,1672))      # 會議室：用返同一間房嘅牆色
fill(4242,4280); fill(6152,6190); fill(8548,8586)
a[:,7595]=a[:,7597]; a[:,7596]=a[:,7597]
g=orig[...,:3].astype(int); green=(g[...,1]>g[...,0]+8)&(g[...,1]>g[...,2]+8)
gm=np.asarray(Image.fromarray((green*255).astype(np.uint8)).filter(ImageFilter.MaxFilter(7)))>0
for c,cx in [(1646,1763),(4272,4337),(8578,8643)]:
    for y in range(280,FLOOR-55):
        for x in range(c-8,cx-15):
            m=2*cx-x
            if gm[y,m] and not green[y,x] and (green[y,m] or g[y,m].sum()<200):
                a[y,x]=orig[y,m]
Image.fromarray(a).convert('RGB').save(D+'new_pano3.png'); Image.fromarray(a).convert('RGB').save(D+'new_pano3.webp',quality=90)
im=Image.fromarray(a); o=Image.new('RGB',(4*260,700))
for i,c in enumerate([1690,4310,7560,8620]): o.paste(im.crop((c-110,100,c+150,800)).convert('RGB'),(i*260,0))
o.save('/tmp/claude-0/fix/check.png')
