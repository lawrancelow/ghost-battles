#!/bin/bash
# sv.sh <目的檔絕對路徑.jpg|.png>：把最新一張瀏覽器 zoom 存檔搬到指定位置
D=/tmp/claude-tool-results/8487f1d5-a141-5493-ab72-c3776b9989e2
f=$(ls -t $D/*.png | head -1); mkdir -p "$(dirname "$1")"
python3 - "$f" "$1" <<'P'
import sys
from PIL import Image
im=Image.open(sys.argv[1]).convert('RGB'); im.save(sys.argv[2],quality=94); print(sys.argv[2],im.size)
P
mkdir -p /tmp/blob_old; mv /tmp/claude-tool-results/8487f1d5-a141-5493-ab72-c3776b9989e2/* /tmp/blob_old/ 2>/dev/null
