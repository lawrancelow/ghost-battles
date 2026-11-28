import sys
from PIL import Image
# st.py out W H tile1:ty tile2:ty ...
out,W,H=sys.argv[1],int(sys.argv[2]),int(sys.argv[3])
c=Image.new('RGB',(W,H))
for a in sys.argv[4:]:
    f,ty=a.rsplit(':',1);ty=int(ty)
    im=Image.open(f).convert('RGB').crop((0,0,min(W,1411),817))
    c.paste(im.crop((0,0,W,min(817,H-ty))),(0,ty))
c.save(out,quality=94);print(out,c.size)
