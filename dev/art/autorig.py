# 用法：python3 autorig.py <id> [id...] —— 從 cut/rg_<id>_*.png 量出關節，寫進 rigs.json 並產生 ../src/rigs.js
import sys, json, os
from PIL import Image
import numpy as np
P = '/home/claude/gb/art/'
def alpha(n): return np.array(Image.open(P + f'cut/{n}.png'))[:, :, 3] > 40
def cx(a, y):
    for d in range(0, 30):
        for yy in (y - d, y + d):
            if 0 <= yy < a.shape[0]:
                xs = np.where(a[yy])[0]
                if len(xs): return float((xs.min() + xs.max()) / 2)
    return a.shape[1] / 2
def ext(a, y):
    xs = np.where(a[int(y)])[0]; return (int(xs.min()), int(xs.max())) if len(xs) else (0, a.shape[1])
db = json.load(open(P + 'rigs.json')) if os.path.exists(P + 'rigs.json') else {}
for id in sys.argv[1:]:
    if id.startswith('-'): continue
    n = lambda k: f'rg_{id}_{k}'
    t = alpha(n('torso')); H, W = t.shape
    y0 = int(H * 0.05); neck = [cx(t, y0), y0 + 6]
    ys = int(H * 0.17); l, r = ext(t, ys); sw = r - l
    shF = [r - sw * 0.16, ys]; shB = [l + sw * 0.16, ys]
    root = [cx(t, int(H * 0.55)), int(H * 0.55)]
    hd = alpha(n('head')); hh, hw = hd.shape
    # 脖子：頭的最底部那一段的中心
    rows = [y for y in range(hh) if hd[y].any()]; yb = rows[-1] - int(hh * 0.06)
    fx = cx(hd, yb) / hw
    def limb(k):
        a = alpha(n(k)); h, w = a.shape
        return [n(k), w, h, [cx(a, int(h * 0.1)), h * 0.1], [cx(a, int(h * 0.86)), h * 0.86]]
    uF, fF, uB, fB = limb('uarmF'), limb('farmF'), limb('uarmB'), limb('farmB')
    L = (uF[4][1] - uF[3][1]) + (fF[4][1] - fF[3][1])
    heads = {'n': n('head')}
    for k, f in (('a', 'head_a'), ('h', 'head_h'), ('s', 'head_a')):
        if os.path.exists(P + f'cut/{n(f)}.png'): heads[k] = n(f)
    db[id] = {'h': int(H + hh * 0.85), 'root': root, 'tailY': H, 'torso': [n('torso'), W, H], 'heads': heads, 'head': [hw, hh, round(fx, 3), 0.93],
              'neck': neck, 'shF': shF, 'shB': shB, 'uF': uF, 'fF': fF, 'uB': uB, 'fB': fB, 'tool': None, 'armS': round(0.66 * H / L, 3)}
    print(id, json.dumps(db[id])[:200])
json.dump(db, open(P + 'rigs.json', 'w'), ensure_ascii=False, indent=0)
open('/home/claude/gb/src/rigs.js', 'w').write('// 自動產生：各角色的木偶關節\nPuppet.addRigs(' + json.dumps(db, ensure_ascii=False) + ');\n')
# 把零件加進打包清單
pk = open(P + 'pack.py').read(); names = sorted({f[:-4] for f in os.listdir(P + 'cut') if f.startswith('rg_') and not f.startswith('rg_afu')})
line = 'RIG2 = ' + json.dumps(names) + '\n'
import re
pk = re.sub(r'RIG2 = .*\n', '', pk).replace('EXTRA = [', line + 'EXTRA = [', 1).replace('PROP + EXTRA + RIG:', 'PROP + EXTRA + RIG + RIG2:').replace('elif n in RIG: sc', 'elif n in RIG or n in RIG2: sc')
open(P + 'pack.py', 'w').write(pk)
