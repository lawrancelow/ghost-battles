import sys
from PIL import Image
d='/tmp/claude-tool-results/1cb63ea7-e3a5-5791-89c3-e4ca371b7df3/'
a,b,out=sys.argv[1:4];vh=int(sys.argv[4]) if len(sys.argv)>4 else 817
a=Image.open(d+a).convert('RGB');b=Image.open(d+b).convert('RGB');H=1005;off=H-vh
c=Image.new('RGB',(1340,H));c.paste(a.crop((0,0,1340,vh)),(0,0));c.paste(b.crop((0,vh-off,1340,vh)),(0,vh));c.save(out,quality=93);print(out)
