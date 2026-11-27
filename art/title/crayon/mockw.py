# 橫版（Steam/PC 16:9）標題畫面效果圖：mockw.py <logo.png> <out.png>
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter
logo,out=sys.argv[1:3]
W,H=1920,1080
c=Image.open('/home/claude/ghost-battles/art/title/cover/V3_office_wide.png').convert('RGB').resize((W,H),Image.LANCZOS)
base=np.array(c).astype(np.float32)
# 左側暗角，讓 Logo、按鈕突出
x=np.arange(W)[None,:]; y=np.arange(H)[:,None]
f=np.clip(1-x/(W*0.5),0,1)**1.5*0.55
base=base*(1-f[...,None])+np.array([12,10,16])*f[...,None]
c=Image.fromarray(base.astype(np.uint8)).convert('RGBA')
lg=Image.open(logo).convert('RGBA'); lw=int(W*0.36); lg=lg.resize((lw,int(lw*lg.height/lg.width)),Image.LANCZOS)
sh=Image.new('RGBA',lg.size,(0,0,0,0)); sh.putalpha(lg.getchannel('A').point(lambda v:int(v*0.6))); sh=sh.filter(ImageFilter.GaussianBlur(14))
lx,ly=60,40; c.alpha_composite(sh,(lx,ly+12)); c.alpha_composite(lg,(lx,ly))
bw=int(W*0.26); by=int(H*0.60); bx=lx+(lw-bw)//2
for nm in ['btn_new2','btn_cont2']:
    b=Image.open('/home/claude/ghost-battles/godot/assets/spr/%s.webp'%nm).convert('RGBA'); b=b.resize((bw,int(bw*b.height/b.width)),Image.LANCZOS)
    c.alpha_composite(b,(bx,by)); by+=b.height+16
d=ImageDraw.Draw(c); F=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc',30,index=2)
for i,t in enumerate(['設置','導入網頁版存檔']):
    x0=bx+i*(bw//2+6); w=bw//2-6; d.rounded_rectangle((x0,by+4,x0+w,by+60),12,fill=(40,30,28,220),outline=(184,154,82),width=2)
    tw=d.textlength(t,font=F); d.text((x0+w/2-tw/2,by+13),t,font=F,fill=(240,212,138))
F2=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',20,index=2)
d.text((W-250,H-34),'版本 0.10.1・補丁 45',font=F2,fill=(255,255,255,110))
c.convert('RGB').save(out); print(out)
