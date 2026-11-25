import sys
from PIL import Image
import numpy as np
a,b,full,out=sys.argv[1:5]
A=Image.open(a).convert('RGB');B=Image.open(b).convert('RGB')
im=Image.new('RGB',(A.width+B.width,A.height));im.paste(A,(0,0));im.paste(B,(A.width,0))
g=np.asarray(im).max(axis=2)
cols=np.where(g.max(axis=0)>12)[0];rows=np.where(g.max(axis=1)>12)[0]
im=im.crop((cols[0],rows[0],cols[-1]+1,rows[-1]+1));im.save(full)
w,h=im.size;cw=int(h*4/3);x=(w-cw)//2
c=im.crop((x,0,x+cw,h)).resize((1024,768),Image.LANCZOS)
c.save(out,'WEBP',quality=88,method=6)
print(im.size,c.size)
