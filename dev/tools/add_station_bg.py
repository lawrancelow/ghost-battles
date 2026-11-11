# 用法：python3 tools/add_station_bg.py <圖片路徑> <鍵名 st_flat|st_bus>
# 把 ChatGPT 生成的背景縮放／裁成 1536×1024（不拉伸：等比縮放後置中裁切），轉 webp，寫入 assets.js 的 SPR_SRC
import sys, re, io, base64
from PIL import Image
src, key = sys.argv[1], sys.argv[2]
im = Image.open(src).convert('RGB'); W, H = 1536, 1024
s = max(W / im.width, H / im.height); im = im.resize((round(im.width * s), round(im.height * s)), Image.LANCZOS)
l, t = (im.width - W) // 2, (im.height - H) // 2; im = im.crop((l, t, l + W, t + H))
buf = io.BytesIO(); im.save(buf, 'WEBP', quality=88, method=6); data = 'data:image/webp;base64,' + base64.b64encode(buf.getvalue()).decode()
p = 'src/assets.js'; a = open(p).read()
m = re.search(r'"' + key + r'":\s*"data:image/\w+;base64,[A-Za-z0-9+/=]+"', a)
if m: a = a[:m.start()] + f'"{key}": "{data}"' + a[m.end():]
else:
    i = a.index('SPR_SRC = {') + len('SPR_SRC = {'); a = a[:i] + f'\n  "{key}": "{data}",' + a[i:]
open(p, 'w').write(a); im.save(f'/tmp/claude-0/{key}.png'); print('ok', key, len(buf.getvalue()) // 1024, 'KB')
