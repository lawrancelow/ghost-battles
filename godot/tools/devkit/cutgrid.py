import sys,json; sys.path.insert(0,'/home/claude/setup')
from fit import *
from PIL import Image
import numpy as np
from scipy import ndimage as nd
# cutgrid.py <png> <cols> <rows> <cw> <ch> <big> name1,name2,...
P,cols,rows,cw,ch,big,names=sys.argv[1],int(sys.argv[2]),int(sys.argv[3]),int(sys.argv[4]),int(sys.argv[5]),int(sys.argv[6]),sys.argv[7].split(',')
im=Image.open(P).convert('RGB'); W,H=im.size; a,dist,bg=cut_mask(im)
L,n=nd.label(nd.binary_dilation(~bg,iterations=6))
cells={}
for i,s in enumerate(nd.find_objects(L)):
    m=(L[s]==i+1); area=m.sum()
    if area<1500: continue
    cy=(s[0].start+s[0].stop)/2; cx=(s[1].start+s[1].stop)/2
    k=int(cy//(H/rows))*cols+int(cx//(W/cols))
    b=cells.get(k); nb=(s[1].start,s[0].start,s[1].stop,s[0].stop)
    cells[k]=nb if b is None else (min(b[0],nb[0]),min(b[1],nb[1]),max(b[2],nb[2]),max(b[3],nb[3]))
m=json.load(open('../spr_manifest.json'))
for k,n in enumerate(names):
    if k not in cells: print('MISSING',n); continue
    b=cells[k]; box=(max(0,b[0]-3),max(0,b[1]-3),min(W,b[2]+3),min(H,b[3]+3))
    part=rgba_from2(P,box,BIG=big)
    s=min((cw-6)/part.width,(ch-6)/part.height); p=part.resize((max(1,int(part.width*s)),max(1,int(part.height*s))),Image.LANCZOS)
    can=Image.new('RGBA',(cw,ch),(0,0,0,0)); can.alpha_composite(p,((cw-p.width)//2,(ch-p.height)//2 if ch==cw else ch-p.height-2))
    can.save(n+'.webp','WEBP',quality=92,method=6); m[n]='res://assets/spr/%s.webp'%n
open('../spr_manifest.json','w').write(json.dumps(m,ensure_ascii=False))
sheet=Image.new('RGBA',(cw*len(names),ch),(60,50,70,255))
for k,n in enumerate(names):
    try: sheet.alpha_composite(Image.open(n+'.webp'),(k*cw,0))
    except Exception: pass
sheet.save('/tmp/cut_check.png'); print('ok',len(cells))
