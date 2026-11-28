import sys
from PIL import Image
# usage: stitch.py out W H viewW file:ty file:ty ...
out,W,H,vw=sys.argv[1],int(sys.argv[2]),int(sys.argv[3]),float(sys.argv[4])
parts=[a.rsplit(':',1) for a in sys.argv[5:]]
first=Image.open(parts[0][0]); s=first.width/vw
Wp,Hp=round(W*s),round(H*s)
c=Image.new('RGB',(Wp,Hp))
for f,ty in parts:
    im=Image.open(f).convert('RGB'); y=round(int(ty)*s)
    h=min(im.height,Hp-y); c.paste(im.crop((0,0,Wp,h)),(0,y))
c.save(out,quality=93); print(out,c.size)
