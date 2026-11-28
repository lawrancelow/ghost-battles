import numpy as np,random,sys
from PIL import Image,ImageDraw,ImageFilter
rnd=random.Random(int(sys.argv[1]) if len(sys.argv)>1 else 3)
W,H=260,380;sheet=Image.new('RGBA',(W*8,H*3),(52,46,52,255))
combos=[(i%8,i%12) for i in range(12)]+[(rnd.randrange(8),rnd.randrange(12)) for _ in range(12)]
for k,(h,b) in enumerate(combos):
    hd=Image.open(f'heads/head_{h}.png');bd=Image.open(f'bodys/body_{b}.png')
    a=np.asarray(bd)[...,3]>40;ys,xs=np.where(a);top=ys.min();nx=xs[ys<top+6].mean()
    ha=np.asarray(hd)[...,3]>40;hy,hx=np.where(ha);
    # chin = bottom of the widest-lower part; use neck column bottom near centre
    wid=ha.sum(1);hw=wid.max();rows=np.where(wid>0.28*hw)[0];bot=rows.max();cx=hx[hy>bot-20].mean() if False else np.where(ha[bot-8])[0].mean()
    s=0.62;bd2=bd.resize((int(bd.width*s),int(bd.height*s)),Image.LANCZOS);hd2=hd.resize((int(hd.width*s),int(hd.height*s)),Image.LANCZOS)
    cv=Image.new('RGBA',(W,H));bx=(W-bd2.width)//2;by=H-bd2.height-8
    if b>=8:
        g=Image.new('RGBA',(W,H));d=ImageDraw.Draw(g)
        col=(190,130,255,170) if b in(9,10) else (255,205,90,170);d.ellipse((40,H-60,W-40,H-12),fill=col);g=g.filter(ImageFilter.GaussianBlur(12));cv=Image.alpha_composite(g,cv)
    cv.alpha_composite(bd2,(bx,by))
    cv.alpha_composite(hd2,(int(bx+nx*s-cx*s),int(by+top*s-bot*s+30*s)))
    sheet.alpha_composite(cv,((k%8)*W,(k//8)*H))
sheet.convert('RGB').save('ghost_mix_test2.jpg',quality=88);print('ok')
