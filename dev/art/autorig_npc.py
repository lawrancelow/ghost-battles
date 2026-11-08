# 用法：python3 autorig_npc.py <id>（例如 npc_ken）—— 活人：頭、身體、手、腿、道具，寫進 rigs.json + ../src/rigs.js
import sys, json, os, re
from PIL import Image
import numpy as np
P = '/home/claude/gb/art/'
def alpha(n): return np.array(Image.open(P + f'cut/{n}.png'))[:, :, 3] > 40
def cx(a, y):
    for d in range(0, 40):
        for yy in (y - d, y + d):
            if 0 <= yy < a.shape[0]:
                xs = np.where(a[yy])[0]
                if len(xs): return float((xs.min() + xs.max()) / 2)
    return a.shape[1] / 2
def ext(a, y):
    xs = np.where(a[int(y)])[0]; return (int(xs.min()), int(xs.max())) if len(xs) else (0, a.shape[1])
db = json.load(open(P + 'rigs.json'))
for id in sys.argv[1:]:
    n = lambda k: f'rg_{id}_{k}'
    t = alpha(n('torso')); H, W = t.shape
    y0 = int(H * 0.04); neck = [cx(t, y0), y0 + 4]
    ys = int(H * 0.16); l, r = ext(t, ys); sw = r - l
    shF = [r - sw * 0.14, ys]; shB = [l + sw * 0.14, ys]
    yh = int(H * 0.86); hl, hr = ext(t, yh); hw_ = hr - hl
    root = [(hl + hr) / 2, yh]
    hipF = [hr - hw_ * 0.28, yh]; hipB = [hl + hw_ * 0.28, yh]
    hd = alpha(n('head')); hh, hw = hd.shape
    rows = [y for y in range(hh) if hd[y].any()]; yb = rows[-1] - int(hh * 0.06)
    fx = cx(hd, yb) / hw
    def limb(k, a0=0.08, a1=0.88):
        a = alpha(n(k)); h, w = a.shape
        return [n(k), w, h, [cx(a, int(h * a0)), h * a0], [cx(a, int(h * a1)), h * a1]]
    uF, fF, uB, fB = limb('uarmF'), limb('farmF'), limb('uarmB'), limb('farmB')
    lF, lB = limb('legF', 0.05, 0.97), limb('legB', 0.05, 0.97)
    legLen = lF[4][1] - lF[3][1]
    legS = round(0.62 * H / legLen, 3)  # Q 版：腿約身體六成
    L = (uF[4][1] - uF[3][1]) + (fF[4][1] - fF[3][1])
    heads = {'n': n('head')}
    for k in 'bsftqxc':
        if os.path.exists(P + f'cut/{n("head_" + k)}.png'): heads[k] = n('head_' + k)
    tool = None
    if os.path.exists(P + f'cut/tool_{id}.png'):
        a = alpha(f'tool_{id}'); h, w = a.shape; tool = [f'tool_{id}', w, h, [cx(a, int(h * 0.85)), h * 0.85]]
    db[id] = {'h': int(H + hh * 0.85 + legLen * legS), 'root': root, 'tailY': yh + legLen * legS, 'torso': [n('torso'), W, H], 'heads': heads,
              'head': [hw, hh, round(fx, 3), 0.94], 'neck': neck, 'shF': shF, 'shB': shB, 'uF': uF, 'fF': fF, 'uB': uB, 'fB': fB,
              'lF': lF, 'lB': lB, 'hipF': hipF, 'hipB': hipB, 'legS': legS, 'tool': tool, 'toolS': {'npc_auntie': 2.4}.get(id, 1), 'armS': round(0.62 * H / L, 3)}
    print(id, 'legS', legS, 'armS', db[id]['armS'], 'heads', list(heads))
json.dump(db, open(P + 'rigs.json', 'w'), ensure_ascii=False, indent=0)
open('/home/claude/gb/src/rigs.js', 'w').write('// 自動產生：各角色的木偶關節\nPuppet.addRigs(' + json.dumps(db, ensure_ascii=False) + ');\n')
pk = open(P + 'pack.py').read(); names = sorted({f[:-4] for f in os.listdir(P + 'cut') if (f.startswith('rg_') and not f.startswith('rg_afu')) or (f.startswith('tool_npc') or f[:-4] in ('tool_niutou','tool_mamian','tool_baiwu'))})
pk = re.sub(r'RIG2 = .*\n', 'RIG2 = ' + json.dumps(names) + '\n', pk)
open(P + 'pack.py', 'w').write(pk)
