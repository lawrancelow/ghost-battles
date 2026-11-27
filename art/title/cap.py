# 用法：cap.py out.png tile1.png tile2.png ...（每張取左上 1024x768，直向拼）
import sys
from PIL import Image
ts=[Image.open(f).convert('RGB').crop((0,0,1024,768)) for f in sys.argv[2:]]
o=Image.new('RGB',(1024,768*len(ts)))
for i,t in enumerate(ts): o.paste(t,(0,768*i))
o.save(sys.argv[1]); print(o.size)
