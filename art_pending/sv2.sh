#!/bin/bash
# sv2.sh <layers名>：最近 4 張 zoom 存檔中，最新的 4:3 全尺寸圖 → _bg_raw.jpg，最新的 3:2 全尺寸圖 → _sheet_raw.jpg
D=/tmp/claude-tool-results/8487f1d5-a141-5493-ab72-c3776b9989e2; O=/home/claude/meeting/vil2/art/layers/$1; mkdir -p $O
python3 - "$O" $(ls -t $D/*.png | head -4) <<'P'
import sys
from PIL import Image
O=sys.argv[1]; done=set()
for f in sys.argv[2:]:
    im=Image.open(f); w,h=im.size
    k='_sheet_raw.jpg' if (w,h)==(1344,896) else '_bg_raw.jpg' if w>=1200 and h>=900 else '_bg_raw.jpg' if (w,h)==(824,1234) else None
    if k and k not in done: im.convert('RGB').save(O+'/'+k,quality=94); done.add(k); print(k,im.size)
P
