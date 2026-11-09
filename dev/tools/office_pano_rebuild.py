from PIL import Image, ImageDraw, ImageFont
import numpy as np
D='/tmp/claude-0/lay/'
P=Image.open(D+'office_pano.png').convert('RGBA'); H=1024; FLOOR=636
AG=Image.open(D+'pano_before_fix.png').convert('RGBA')   # 幫手改過會議室（拎走咗會議枱）嘅版本
CH=P.crop((5860,0,5960,H))                                 # 乾淨牆身（無燈飾）
def plain(w):
    out=Image.new('RGBA',(w,H)); x=0; k=0
    while x<w: out.alpha_composite(CH if k%2==0 else CH.transpose(Image.FLIP_LEFT_RIGHT),(x,0)); x+=100; k+=1
    return out
def crop(a,b): return P.crop((a,0,b,H))
segs=[('boss',[(0,1506)]),('meeting',[(4458,5964)]),('lobby',[('plain',270),(2590,2982),('plain',238)]),
      ('main',[(1506,2560),(1620,2366)]),('pantry',[(2982,4458)]),('wc',[('plain',700)]),
      ('qa',[(1506,2560),('plain',346)]),('server',[('plain',1200)]),('rest',[('plain',380),(1110,1506),('plain',24)])]
WALL=110; out=Image.new('RGBA',(12168,H)); x=0; rooms=[]
for i,(k,lst) in enumerate(segs):
    x0=x
    for p in lst:
        im=plain(p[1]) if p[0]=='plain' else crop(*p); out.alpha_composite(im,(x,0)); x+=im.width
    rooms.append((k,x0,x))
    if i<len(segs)-1: x+=WALL
# 會議室：用幫手版本（會議枱已經剪走、補好牆同地毯）
out.paste(AG.crop((1616,0,3122,H)),(1616,0))
a=np.asarray(out).copy(); ch=np.asarray(CH)
# 舊柱子殘留：逐層補（天花＝隔籬一行延續、牆身＝乾淨牆紋理、地毯＝隔籬一行延續）
spans=[(1469,1506),(1616,1639),(3856,3898),(4242,4265),(6152,6175),(7597,7628),(8548,8571),(12107,12148)]
R=[(r0,r1) for _,r0,r1 in rooms]
for x0,x1 in spans:
    rr=[r for r in R if r[0]<=x0<r[1]][0]; left=(x0-rr[0])<(rr[1]-x1); nb=x1+1 if left else x0-2
    col=a[:,nb].copy()
    # 天花底：由上面數落，第一段連續 12 行唔係紫色（B<=R）嘅位置
    top=0
    for y in range(60,FLOOR):
        seg=col[y:y+12]
        if all(int(p[2])<=int(p[0]) for p in seg): top=y; break
    w=x1-x0; src=x1+1 if left else x0-w-1   # 天花同地毯：成段照搬隔籬（唔再用一行拉闊，冇條紋）
    a[:top,x0:x1]=a[:top,src:src+w]; a[FLOOR-30:,x0:x1]=a[FLOOR-30:,src:src+w]
    for xx in range(x0,x1): a[top:FLOOR-30,xx]=ch[top:FLOOR-30,(xx-x0)%100]
out=Image.fromarray(a); d=ImageDraw.Draw(out); PRE=np.asarray(out).copy(); d0=d
# 牆＋門口
for (k,a0,b0),(k2,a2,b2) in zip(rooms,rooms[1:]):
    x=b0; d.rectangle((x,0,x+WALL,H),fill=(222,204,178,255)); d.rectangle((x,0,x+5,H),fill=(160,138,116,255)); d.rectangle((x+WALL-5,0,x+WALL,H),fill=(160,138,116,255))
    d.rectangle((x,FLOOR-6,x+WALL,FLOOR+4),fill=(96,70,110,255))
    d.rectangle((x+12,FLOOR-336,x+WALL-12,FLOOR+2),fill=(92,64,46,255)); d.rectangle((x+20,FLOOR-326,x+WALL-20,FLOOR+2),fill=(30,24,34,255)); d.rectangle((x+20,FLOOR-326,x+40,FLOOR+2),fill=(150,112,80,255))
# 洗手間：兩扇門靠左（男、女），右邊留位畀影印機
wc=[r for r in rooms if r[0]=='wc'][0]
f=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc',40)
for j,(t,c) in enumerate([('男',(70,110,190)),('女',(200,80,115))]):
    a0=wc[1]+40+j*240; top=FLOOR-360; w=180
    d.rectangle((a0-12,top-12,a0+w+12,FLOOR+2),fill=(110,80,60,255)); d0.rectangle((a0-14,top-14,a0+w+14,FLOOR+2),outline=(58,40,36,255),width=4); d.rectangle((a0,top,a0+w,FLOOR+2),fill=(176,140,104,255)); d0.rectangle((a0,top,a0+w,FLOOR+2),outline=(70,48,40,255),width=3)
    for yy in (top+36,top+192): d.rectangle((a0+20,yy,a0+w-20,yy+124),outline=(140,106,78,255),width=4)
    d.rounded_rectangle((a0+w/2-32,top-74,a0+w/2+32,top-18),10,fill=c+(255,),outline=(40,30,40,255),width=3); d.text((a0+w/2-20,top-74),t,font=f,fill=(255,255,255,255))
    d.rectangle((a0+w-28,top+186,a0+w-18,top+220),fill=(210,190,130,255)); d.rectangle((a0+w-36,top+196,a0+w-10,top+206),fill=(210,190,130,255))
    d.rectangle((a0,FLOOR-4,a0+w,FLOOR+2),fill=(20,16,24,255))
# 伺服器房
sv=[r for r in rooms if r[0]=='server'][0]; sx=sv[1]
d.rectangle((sx+40,150,sx+1160,FLOOR+6),outline=(120,160,190,255),width=10)
for i in range(6):
    a0=sx+90+i*180; d.rectangle((a0,250,a0+130,FLOOR),fill=(32,34,44,255)); d.rectangle((a0,250,a0+130,262),fill=(70,74,90,255))
    for r in range(10):
        y=275+r*36; d.rectangle((a0+10,y,a0+120,y+26),fill=(46,50,62,255))
        for kk in range(3): d.ellipse((a0+18+kk*14,y+9,a0+26+kk*14,y+17),fill=[(90,255,140),(255,190,80),(90,200,255)][(i+r+kk)%3]+(255,))
# 蠟筆紋理：用乾淨牆身嘅明暗起伏（高頻）乘落程式畫嘅位，再輕輕模糊邊
from PIL import ImageFilter
g=np.asarray(CH.convert('L')).astype(float); tex=np.tile(np.concatenate([g,g[:,::-1]],1),(1,int(np.ceil(12168/200))))[:,:12168]
blur=np.asarray(Image.fromarray(tex.astype(np.uint8)).filter(ImageFilter.GaussianBlur(6))).astype(float)
hf=np.clip(1+(tex-blur)/110,0.8,1.2)
A=np.asarray(out).astype(float); m=(np.abs(A[...,:3]-PRE[...,:3]).sum(-1)>0).astype(float)[...,None]
A[...,:3]=A[...,:3]*(1-m)+np.clip(A[...,:3]*hf[...,None],0,255)*m
out=Image.fromarray(A.astype(np.uint8))
out.convert('RGB').save(D+'new_pano2.png'); out.convert('RGB').save(D+'new_pano2.webp',quality=90)
c=Image.new('RGB',(8*300,520))
for i,(x0,x1) in enumerate(spans):
    t=out.crop((max(0,x0-110),150,min(12168,x1+110),680)).convert('RGB'); c.paste(t.resize((290,int(t.height*290/t.width))),(i*300,0))
c.save(D+'pf_all.jpg'); out.crop((7600,100,8560,700)).convert('RGB').save(D+'wc_new.jpg')
print('ok')
