# 合成完整標題畫面效果圖（手機 450x975 比例，輸出 900x1950）
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter
cov, out, label = sys.argv[1], sys.argv[2], sys.argv[3]
W,H=900,1950
c=Image.new('RGB',(W,H),(46,36,34))
cv=Image.open(cov).convert('RGB'); cw=int(H*cv.width/cv.height); cv=cv.resize((cw,H),Image.LANCZOS)
c.paste(cv,(-(cw-W)//2,0)); ch=H*2
# 封面底部漸變接底色 + 底部霧
g=np.zeros((H,W),np.float32)
for y in range(H):
    t=(y-ch*0.78)/(ch*0.22); g[y]=np.clip(t,0,1)
base=np.array(c).astype(np.float32); bg=np.array([30,22,24],np.float32)
base=base*(1-g[...,None])+bg*g[...,None]
f=np.clip((np.arange(H)-H*0.62)/(H*0.38),0,1)[:,None]*0.72
base=base*(1-f[...,None])+np.array([12,10,16])*f[...,None]
c=Image.fromarray(base.astype(np.uint8)).convert('RGBA')
# Logo
lg=Image.open('/home/claude/art/title/logo/logo_v1.png'); lw=int(W*0.80); lg=lg.resize((lw,int(lw*lg.height/lg.width)),Image.LANCZOS)
sh=Image.new('RGBA',lg.size,(0,0,0,0)); sh.putalpha(lg.getchannel('A').point(lambda v:int(v*0.6))); sh=sh.filter(ImageFilter.GaussianBlur(12))
y0=int(H*0.02); c.alpha_composite(sh,((W-lw)//2,y0+10)); c.alpha_composite(lg,((W-lw)//2,y0))
# 按鈕
F=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc',30,index=2)
bw=int(W*0.74)
by=int(H*0.725)
for name in ['btn_new2','btn_cont2']:
    b=Image.open('/home/claude/art/title/btn/%s.webp'%name).convert('RGBA'); b=b.resize((bw,int(bw*b.height/b.width)),Image.LANCZOS)
    c.alpha_composite(b,((W-bw)//2,by)); by+=b.height+18
d=ImageDraw.Draw(c)
for i,t in enumerate(['設置','導入網頁版存檔']):
    x=W//2-230+i*260; d.rounded_rectangle((x,by+4,x+200,by+62),12,fill=(40,30,28,220),outline=(184,154,82),width=2)
    tw=d.textlength(t,font=F); d.text((x+100-tw/2,by+14),t,font=F,fill=(240,212,138))
F2=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',20,index=2)
d.text((W-250,H-36),'版本 0.10.1・補丁 45',font=F2,fill=(255,255,255,110))
c.convert('RGB').save(out)
# 審批版（≤1400x2200）：左效果圖，右原封面，上中文標註
R=Image.new('RGB',(1400,1300),(46,36,34)); dd=ImageDraw.Draw(R)
FT=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Black.ttc',40,index=2)
FS=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',26,index=2)
dd.text((30,20),label.split('|')[0],font=FT,fill=(243,214,138))
dd.text((30,80),label.split('|')[1],font=FS,fill=(230,220,200))
m=Image.open(out).resize((540,1170),Image.LANCZOS); R.paste(m,(30,120))
cc=Image.open(cov).convert('RGB').resize((520,780),Image.LANCZOS); R.paste(cc,(620,120))
dd.text((620,915),'左：完整標題畫面效果（手機比例）',font=FS,fill=(230,220,200))
dd.text((620,955),'右：封面原圖（無文字，Logo、按鈕由遊戲疊上）',font=FS,fill=(230,220,200))
R.save(out.replace('.png','_review.png'))
