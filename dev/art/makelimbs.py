# limbs.json + weapons.json → src/limbdata.js
import json, math
P = '/home/claude/gb/art/'
L = json.load(open(P + 'limbs.json')); Wp = json.load(open(P + 'weapons.json'))
from PIL import Image
out = {'chars': {}, 'weapons': Wp}
for id, S in L.items():
    im = Image.open(P + f'cut/{id}.png'); W, H = im.size
    g = S.get('grip', S['pivot']); t = S['tip']
    hold = math.degrees(math.atan2((t[0] - g[0]) * W, -(t[1] - g[1]) * H))
    out['chars'][id] = {'pivot': S['pivot'], 'grip': g, 'hold': hold, 'weapon': S.get('weapon'), 'lift': S.get('lift', [0, 0]), 'K': S.get('K'), 'behind': S.get('behind', 28), 'front': S.get('front', 1), 'tip': S.get('tip'), 'behindLo': S.get('behindLo'), 'still': S.get('still'), 'swing': S.get('swing')}
    for k in ('hk', 'wbehind', 'nativeR'):  # 選用：手腕分擔轉角、武器在身體後面的角度範圍、原圖面朝右
        if k in S: out['chars'][id][k] = S[k]
open('/home/claude/gb/src/limbdata.js', 'w').write('// 自動產生：從原圖拆出的手和武器\nconst LIMBS_DATA = ' + json.dumps(out, ensure_ascii=False) + ';\n')
print('chars', list(out['chars']), 'weapons', list(Wp))
