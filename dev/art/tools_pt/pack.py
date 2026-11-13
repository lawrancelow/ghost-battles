# 把 art/patrol/*.png 打包成 src/patrol_assets.js（webp data URL）
import base64, io, glob, os
from PIL import Image
out={}
for f in sorted(glob.glob('/home/claude/gb/art/patrol/*.png')):
    k=os.path.basename(f)[:-4]; im=Image.open(f); b=io.BytesIO()
    if k.startswith('ground'): im.convert('RGB').save(b,'WEBP',quality=80,method=6)
    else: im.save(b,'WEBP',quality=86,method=6)
    out[k]='data:image/webp;base64,'+base64.b64encode(b.getvalue()).decode()
js='// 夜班巡陰：地面、擺設、設施圖（老闆 ChatGPT Plus 生成，蠟筆畫風；原圖 art/patrol/*.png，用 art/tools_pt/pack.py 重打包）\nconst PT_IMG_SRC = {\n'+',\n'.join(f"  {k}:'{v}'" for k,v in out.items())+'\n};\n'
open('/home/claude/gb/src/patrol_assets.js','w').write(js); print(len(out), len(js))
