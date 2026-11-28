#!/bin/bash
# sv2.sh <layers名>：暫存目錄裡最新的 1268x952 → _bg_raw.jpg、最新的 1344x896 → _sheet_raw.jpg；存完把暫存檔搬走（目錄有 128MB 上限，滿了就不再存）
D=/tmp/claude-tool-results/8487f1d5-a141-5493-ab72-c3776b9989e2; O=/home/claude/meeting/vil2/art/layers/$1; mkdir -p $O /tmp/blob_old
python3 - "$O" $(ls -t $D/*.png) <<'P'
import sys
from PIL import Image
O=sys.argv[1]; done=set()
for f in sys.argv[2:]:
    im=Image.open(f); k={(1344,896):'_sheet_raw.jpg',(1268,952):'_bg_raw.jpg',(824,1234):'_bg_raw.jpg'}.get(im.size)
    if k and k not in done: im.convert('RGB').save(O+'/'+k,quality=94); done.add(k); print(k,im.size)
print('saved',sorted(done))
P
mv $D/* /tmp/blob_old/ 2>/dev/null
