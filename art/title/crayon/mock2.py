# 用法：mock2.py <logo.png> <out_prefix> <版本名> <說明>
# 出：<prefix>.png（直屏 900x1950 效果圖）、<prefix>_review.png（舊版對比審批圖）
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter
logo, pre, name, note = sys.argv[1:5]
cov='/home/claude/ghost-battles/art/title/cover/V3_office.png'
W,H=900,1950
c=Image.new('RGB',(W,H),(46,36,34))
cv=Image.open(cov).convert('RGB'); cw=int(H*cv.width/cv.height); cv=cv.resize((cw,H),Image.LANCZOS)
c.paste(cv,(-(cw-W)//2,0))
base=np.array(c).astype(np.float32)
f=np.clip((np.arange(H)-H*0.62)/(H*0.38),0,1)[:,None]*0.72
base=base*(1-f[...,None])+np.array([12,10,16])*f[...,None]
c=Image.fromarray(base.astype(np.uint8)).convert('RGBA')
lg=Image.open(logo).convert('RGBA'); lw=int(W*0.86); lg=lg.resize((lw,int(lw*lg.height/lg.width)),Image.LANCZOS)
sh=Image.new('RGBA',lg.size,(0,0,0,0)); sh.putalpha(lg.getchannel('A').point(lambda v:int(v*0.55))); sh=sh.filter(ImageFilter.GaussianBlur(12))
y0=int(H*0.025); c.alpha_composite(sh,((W-lw)//2,y0+10)); c.alpha_composite(lg,((W-lw)//2,y0))
F=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc',30,index=2)
bw=int(W*0.74); by=int(H*0.725)
for nm in ['btn_new2','btn_cont2']:
    b=Image.open('/home/claude/ghost-battles/godot/assets/spr/%s.webp'%nm).convert('RGBA'); b=b.resize((bw,int(bw*b.height/b.width)),Image.LANCZOS)
    c.alpha_composite(b,((W-bw)//2,by)); by+=b.height+18
d=ImageDraw.Draw(c)
for i,t in enumerate(['設置','導入網頁版存檔']):
    x=W//2-230+i*260; d.rounded_rectangle((x,by+4,x+200,by+62),12,fill=(40,30,28,220),outline=(184,154,82),width=2)
    tw=d.textlength(t,font=F); d.text((x+100-tw/2,by+14),t,font=F,fill=(240,212,138))
F2=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',20,index=2)
d.text((W-250,H-36),'版本 0.10.1・補丁 45',font=F2,fill=(255,255,255,110))
c.convert('RGB').save(pre+'.png')
# 審批：左舊版（老闆貼回）、右新版，上方大圖 Logo 細節
R=Image.new('RGB',(1400,2000),(40,32,30)); dd=ImageDraw.Draw(R)
FT=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Black.ttc',42,index=2)
FS=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',26,index=2)
dd.text((30,20),name,font=FT,fill=(243,214,138)); dd.text((30,84),note,font=FS,fill=(230,220,200))
old=Image.open('/mnt/user-data/uploads/b00196f7-image.png').convert('RGB').resize((600,1280),Image.LANCZOS)
new=Image.open(pre+'.png').resize((600,1300),Image.LANCZOS)
R.paste(old,(60,190)); R.paste(new,(740,180))
dd.text((60,140),'現版（老闆貼回的畫面）',font=FS,fill=(200,190,170)); dd.text((740,140),'新版：蠟筆風標題',font=FS,fill=(243,214,138))
lz=Image.open(logo).convert('RGBA'); lz.thumbnail((1340,440)); bgc=Image.new('RGBA',lz.size,(28,26,32,255)); bgc.alpha_composite(lz)
R.paste(bgc.convert('RGB'),((1400-lz.width)//2,1530)); dd.text((30,1495),'標題放大看筆觸（透明背景）',font=FS,fill=(200,190,170))
R.save(pre+'_review.png'); print(R.size)
