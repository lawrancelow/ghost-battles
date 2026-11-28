#!/usr/bin/env python3
# sheet.py <out.jpg> <標題> 檔1=說明 檔2=說明 ...  帶編號總覽圖
import sys
from PIL import Image,ImageDraw,ImageFont
out,title=sys.argv[1],sys.argv[2]; items=[a.split('=',1) for a in sys.argv[3:]]
import glob
fp='/home/claude/wt/main/godot/fonts/sans_b.otf'
F=ImageFont.truetype(fp,30); FT=ImageFont.truetype(fp,44)
cols=2 if len(items)<=4 else 3; cw=900; pad=16; th=[]
ims=[]
for f,_ in items:
    im=Image.open(f).convert('RGB'); im=im.resize((cw,int(im.height*cw/im.width)),Image.LANCZOS); ims.append(im)
rows=(len(items)+cols-1)//cols; rh=[max(im.height for im in ims[r*cols:(r+1)*cols])+56 for r in range(rows)]
W=cols*(cw+pad)+pad; H=80+sum(rh)+pad*(rows+1)
c=Image.new('RGB',(W,H),(27,22,32)); d=ImageDraw.Draw(c); d.text((pad,16),title,font=FT,fill=(239,230,242))
y=80+pad
for r in range(rows):
    for k in range(cols):
        i=r*cols+k
        if i>=len(items): break
        x=pad+k*(cw+pad); c.paste(ims[i],(x,y)); d.text((x,y+ims[i].height+8),f'{i+1}. {items[i][1]}',font=F,fill=(255,214,120))
    y+=rh[r]+pad
c.save(out,quality=88); print(out,c.size)
