# 軍團空手圖入庫：/home/claude/art/out/NoWeapon/HC_lg_<k>_NoWeapon.png → assets/spr/nwp_lg_<k>.webp（同原圖一樣尺寸）
#   ＋ spr_manifest.json 登記 nwp_lg_<k> ＋ .import（參數抄原圖 lg_<k>.webp.import，冇 uid，之後 godot --import 補）
#   遊戲取圖：game/soul/ace_art.gd NWP 名單 → Spr.key_for 自動換（冇圖照用原圖）
# python3 lgnw_install.py [k ...]（唔俾就裝晒資料夾入面有嘅）
import sys, os, re, json, glob
from PIL import Image
G = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
SRC = os.environ.get('NW_SRC', '/home/claude/art/out/NoWeapon')
ks = sys.argv[1:] or sorted(re.match(r'HC_lg_(.+)_NoWeapon\.png', os.path.basename(f)).group(1) for f in glob.glob(SRC + '/HC_lg_*_NoWeapon.png'))
mp = G + '/assets/spr_manifest.json'; man = json.load(open(mp))
for k in ks:
    src = f'{SRC}/HC_lg_{k}_NoWeapon.png'; o = f'{G}/assets/spr/lg_{k}.webp'; d = f'{G}/assets/spr/nwp_lg_{k}.webp'
    im = Image.open(src).convert('RGBA'); assert im.size == Image.open(o).size, (k, im.size)
    im.save(d, 'WEBP', quality=92, method=6, exact=True)
    t = open(o + '.import').read().replace(f'lg_{k}.webp', f'nwp_lg_{k}.webp')
    t = re.sub(r'^uid=.*\n', '', t, flags=re.M); t = re.sub(r'-[0-9a-f]{32}\.ctex', '-x.ctex', t)
    if not os.path.exists(d + '.import'): open(d + '.import', 'w').write(t)
    man['nwp_lg_' + k] = f'res://assets/spr/nwp_lg_{k}.webp'
    print('nwp_lg_' + k, im.size)
open(mp, 'w').write(json.dumps(man, ensure_ascii=False, separators=(',', ':')))
print('之後：cd godot && /opt/godot/Godot_v4.3-stable_linux.x86_64 --headless --path . --import')
