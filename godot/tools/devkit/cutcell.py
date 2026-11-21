# cutcell.py <png> <cols> <rows> name:WxH,...   （按格切；去白邊；底部對齊；寫入當前目錄 + ../spr_manifest.json）
import sys,json; sys.path.insert(0,'/home/claude/setup')
from fit import rgba_from2
from PIL import Image
import numpy as np
from scipy import ndimage as nd
P=sys.argv[1]; C=int(sys.argv[2]); R=int(sys.argv[3]); items=sys.argv[4].split(',')
im=Image.open(P); W,H=im.size
m=json.load(open('../spr_manifest.json'))
def defringe(p):
    a=np.array(p).astype(float); al=a[...,3]>0; lum=a[...,:3].min(axis=2)
    for it in range(3):
        edge=al & nd.binary_dilation(~al,iterations=2); kill=edge&(lum>170)
        if not kill.any(): break
        al[kill]=False
    lab,n=nd.label(al)
    if n>1:
        sz=nd.sum(al,lab,range(1,n+1)); keep=[i+1 for i,s in enumerate(sz) if s>=0.03*sz.max()]; al&=np.isin(lab,keep)
    a[...,3]=np.where(al,a[...,3],0); o=Image.fromarray(a.astype(np.uint8),'RGBA'); return o.crop(o.getbbox())
for k,it in enumerate(items):
    if not it or it=='-': continue
    n,wh=it.split(':'); cw,ch=map(int,wh.split('x'))
    r,c=divmod(k,C); box=(int(c*W/C),int(r*H/R),int((c+1)*W/C),int((r+1)*H/R))
    part=defringe(rgba_from2(P,box,BIG=120))
    s=min((cw-6)/part.width,(ch-6)/part.height); p=part.resize((max(1,int(part.width*s)),max(1,int(part.height*s))),Image.LANCZOS)
    can=Image.new('RGBA',(cw,ch),(0,0,0,0)); can.alpha_composite(p,((cw-p.width)//2,ch-p.height-2)); can.save(n+'.webp','WEBP',quality=92,method=6)
    m[n]='res://assets/spr/%s.webp'%n
open('../spr_manifest.json','w').write(json.dumps(m,ensure_ascii=False))
names=[i.split(':')[0] for i in items if i and i!='-']
sh=Image.new('RGB',(len(names)*170,170),(60,50,60))
for i,n in enumerate(names):
    q=Image.open(n+'.webp').convert('RGBA'); q.thumbnail((165,165)); sh.paste(q,(i*170,0),q)
sh.save('/tmp/cutcell_last.jpg',quality=85); print('ok',len(names))
