# 直身背景（1024x1536）：上下兩半截圖拼返 → 768x1152 webp（同其他 bg_ 一樣大細）
import sys
from PIL import Image
import numpy as np
a,b,full,out=sys.argv[1:5]
A=Image.open(a).convert('RGB');B=Image.open(b).convert('RGB')
im=Image.new('RGB',(A.width,A.height+B.height));im.paste(A,(0,0));im.paste(B,(0,A.height))
g=np.asarray(im).max(axis=2)
cols=np.where(g.max(axis=0)>12)[0];rows=np.where(g.max(axis=1)>12)[0]
im=im.crop((cols[0],rows[0],cols[-1]+1,rows[-1]+1));im.save(full)
w,h=im.size;ch=int(w*1.5);y=max(0,(h-ch)//2)
c=im.crop((0,y,w,y+min(ch,h))).resize((768,1152),Image.LANCZOS)
c.save(out,'WEBP',quality=88,method=6)
print(im.size,c.size)
