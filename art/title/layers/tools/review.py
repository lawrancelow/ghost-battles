from PIL import Image, ImageDraw, ImageFont
import numpy as np, json
F=lambda s: ImageFont.truetype('/home/claude/ghost-battles/godot/fonts/sans_b.otf',s)
R='/home/claude/ghost-battles/art/title'
def checker(w,h,c=14):
    a=np.zeros((h,w,3),np.uint8)+70; yy,xx=np.mgrid[0:h,0:w]; a[((yy//c+xx//c)%2)==0]=110; return Image.fromarray(a)
def onchk(p,size):
    L=Image.open(p).convert('RGBA'); bb=L.getbbox(); L=L.crop(bb); L.thumbnail(size); c=checker(*size); c.paste(L,((size[0]-L.width)//2,(size[1]-L.height)//2),L); return c
def sheet(t,cover):
    d=f'{R}/layers/{t}'; W=1400
    can=Image.new('RGB',(W,1400),(24,22,28)); dr=ImageDraw.Draw(can)
    if t=='portrait': tw=(300,450)
    else: tw=(440,248)
    x=20;y=50
    dr.text((20,10),'直屏 1024×1536' if t=='portrait' else '橫版 1672×941',font=F(28),fill=(240,220,160))
    for lab,img in [('原圖',Image.open(cover)),('分層疊回（逐像素一致，差異 0）',Image.open(f'{d}/_recomp.png')),('L0 背景（角色已移除並補畫）',Image.open(f'{d}/L0_background.png'))]:
        im=img.convert('RGB').resize(tw); can.paste(im,(x,y+34)); dr.text((x,y),lab,font=F(20),fill=(230,230,230)); x+=tw[0]+20
    y+=tw[1]+60; x=20; cell=(205,205) if t=='portrait' else (215,170)
    names=[('L1_ghosts_left','L1 遠處鬼怪・左'),('L1_ghosts_right','L1 遠處鬼怪・右'),('L2_ceiling_left','L2 天花板倒吊鬼・左'),('L2_ceiling_right','L2 天花板爬出鬼・右'),('L3_male','L3 男主'),('L3_female','L3 女主')]
    for f,lab in names:
        c=onchk(f'{d}/{f}.png',cell); can.paste(c,(x,y+30)); dr.text((x,y),lab,font=F(18),fill=(230,230,230)); x+=cell[0]+20
    y+=cell[1]+70
    g=Image.open(f'/home/claude/layerwork/glow_{t}.png'); g=g.resize((tw[0],tw[1]))
    can.paste(g,(20,y+30)); dr.text((20,y),'光源遮罩：黃＝日光燈　綠＝電腦螢幕　橙＝檯燈　紅＝紅月',font=F(18),fill=(230,230,230))
    tx=40+tw[0]
    for i,l in enumerate(['建議動法（程序組）：','・背景、遠處鬼怪：視差很小（鬼怪下半身被隔板擋住，位移≤3px）','・天花板兩隻鬼：以頂部為支點慢慢擺動 ±2.5°','・男女主：上下漂浮 ±4px＋輕微呼吸縮放，兩人錯開節奏','・日光燈偶爾閃、螢幕明暗呼吸、檯燈暖光、紅月光暈慢脈動','・所有層同尺寸、位置對齊，直接疊放即可']):
        dr.text((tx,y+30+i*30),l,font=F(18),fill=(240,220,160) if i==0 else (220,220,220))
    return can.crop((0,0,W,y+45+max(tw[1],200)))
a=sheet('portrait',f'{R}/cover/V3_office.png'); b=sheet('wide',f'{R}/cover/V3_office_wide.png')
c=Image.new('RGB',(1400,a.height+b.height+20),(24,22,28)); c.paste(a,(0,0)); c.paste(b,(0,a.height+20))
if c.height>2200: c=c.resize((int(1400*2200/c.height),2200))
c.save('/home/claude/layerwork/HC_GB_Title_Layers_Review.png'); print(c.size)
