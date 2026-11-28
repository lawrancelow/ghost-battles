#!/bin/bash
# grab.sh <類別> <名字>：把最新一張瀏覽器 zoom 存檔搬進 art_pending
D=/tmp/claude-tool-results/8487f1d5-a141-5493-ab72-c3776b9989e2
f=$(ls -t $D/*.png | head -1)
python3 - "$f" "/home/claude/meeting/art_pending/$1/$2.jpg" <<'P'
import sys
from PIL import Image
im=Image.open(sys.argv[1]).convert('RGB'); im.save(sys.argv[2],quality=94); print(sys.argv[2],im.size)
P
