# sheet.py <out.jpg> k1 k2 ...：審批對照圖（左原圖右空手版，中文名＋id），≤1400×2200
import sys, json
from PIL import Image, ImageDraw, ImageFont
G=json.load(open('/home/claude/wt/p44/godot/data/nat/legion.json'))['GHOSTS']
F=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc',22)
out=sys.argv[1]; ks=sys.argv[2:]
cols=2; cw=700; ih=300; rh=ih+40
rows=(len(ks)+cols-1)//cols
S=Image.new('RGB',(cols*cw,rows*rh),(235,235,235)); d=ImageDraw.Draw(S)
def ongray(im):
    b=Image.new('RGBA',im.size,(200,200,200,255)); b.alpha_composite(im); return b.convert('RGB')
for i,k in enumerate(ks):
    x=(i%cols)*cw; y=(i//cols)*rh
    o=Image.open(f'/home/claude/wt/p44/godot/assets/spr/lg_{k}.webp').convert('RGBA')
    n=Image.open(f'/home/claude/art/out/NoWeapon/HC_lg_{k}_NoWeapon.png').convert('RGBA')
    for j,im in enumerate([o,n]):
        im=ongray(im); sc=min((cw/2-16)/im.width,ih/im.height); im=im.resize((round(im.width*sc),round(im.height*sc)),Image.LANCZOS)
        S.paste(im,(x+8+j*(cw//2)+(cw//2-16-im.width)//2,y+36))
    d.text((x+10,y+6),f"{G.get('lg_'+k,{}).get('name','?')}  lg_{k}   （左原圖｜右空手）",font=F,fill=(20,20,20))
    d.line([(x,y+rh-1),(x+cw,y+rh-1)],fill=(160,160,160),width=2); d.line([(x+cw-1,y),(x+cw-1,y+rh)],fill=(160,160,160),width=2)
if S.height>2200: S=S.resize((round(S.width*2200/S.height),2200),Image.LANCZOS)
S.save(out,quality=90); print(out,S.size)
