# 用法：python3 take.py <輸出名> <tool-result 檔...>  —— 把 @@i@@...@@END@@ 分段接回 webp
import json,re,sys,base64
out=sys.argv[1]; parts={}
for f in sys.argv[2:]:
    t=''.join(x.get('text','') for x in json.load(open(f)))
    m=re.search(r'@@(\d+)@@(.*?)@@END@@',t,re.S); parts[int(m.group(1))]=m.group(2)
s=''.join(parts[i] for i in range(len(parts))).split(',',1)[1]
open(f'raw/{out}.webp','wb').write(base64.b64decode(s))
json.dump([{'type':'text','text':'B64START'+s+'B64END'}],open(f'/tmp/claude-0/{out}.json','w'))
from PIL import Image; im=Image.open(f'raw/{out}.webp'); print(out, im.size, im.mode)
im.convert('RGBA').resize((im.width//2,im.height//2)).save(f'/tmp/claude-0/{out}_prev.png')
