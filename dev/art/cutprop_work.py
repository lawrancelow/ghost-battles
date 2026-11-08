# 崗位打工用的小道具：從建築原圖拆出一小塊（全部是原圖像素，不重畫）
# 用法：python3 cutprop_work.py      輸出 cut/<建築>__<名字>.png（裁到道具本身大小，四周留 3px）
# 規格：src = 原圖；poly = 只取多邊形內（原圖比例）；biggest = 只留最大一塊（清掉碎屑）
import json
import numpy as np, cv2
from PIL import Image
P = '/home/claude/gb/art/cut/'
SPEC = {
    # 伐木場：柴堆最上面那根橫躺的木頭
    'wood__log':   { 'src':'wood', 'poly':[(0.055,0.705),(0.08,0.686),(0.14,0.688),(0.25,0.714),(0.28,0.722),(0.305,0.726),(0.328,0.740),(0.340,0.770),(0.328,0.800),(0.298,0.813),(0.265,0.802),(0.08,0.763),(0.055,0.740)] },
    # 倉庫：左邊上面那個木箱、右邊最上面那袋米
    'store__crate':{ 'src':'store', 'poly':[(0.065,0.535),(0.10,0.515),(0.27,0.515),(0.291,0.535),(0.291,0.680),(0.280,0.695),(0.075,0.695),(0.062,0.680)] },
    'store__sack': { 'src':'store', 'poly':[(0.62,0.700),(0.66,0.640),(0.70,0.612),(0.70,0.590),(0.76,0.580),(0.84,0.590),(0.84,0.615),(0.885,0.650),(0.905,0.690),(0.90,0.712),(0.84,0.722),(0.70,0.725),(0.625,0.716)] },
    # 包子鋪：屋頂上那籠蒸籠（有蓋）、桌上那籠包子
    'bun__steamer':{ 'src':'bun', 'poly':[(0.622,0.050),(0.66,0.012),(0.74,0.000),(0.81,0.020),(0.812,0.060),(0.810,0.180),(0.78,0.197),(0.66,0.197),(0.624,0.180)] },
    'bun__basket': { 'src':'bun', 'poly':[(0.330,0.610),(0.37,0.575),(0.40,0.560),(0.44,0.552),(0.47,0.565),(0.505,0.600),(0.512,0.660),(0.49,0.685),(0.35,0.685),(0.330,0.660)] },
    # 一顆包子：餓鬼王手上那顆（cutpiece.py 已拆好），裁成小圖
    'bun__bun':    { 'src':'eguiking__bun', 'poly':[(0,0),(0.3,0),(0.3,0.4),(0,0.4)] },
    # 化寶爐：飄著的那張金紙、左下那疊金紙
    'furnace__paper':{ 'src':'furnace', 'poly':[(0.105,0.505),(0.175,0.486),(0.243,0.562),(0.238,0.590),(0.165,0.598),(0.118,0.548)] },
    'furnace__stack':{ 'src':'furnace', 'poly':[(0.115,0.800),(0.25,0.775),(0.385,0.790),(0.390,0.900),(0.30,0.918),(0.12,0.905),(0.105,0.860)] },
}

def poly_mask(W, H, pts):
    m = np.zeros((H, W), np.uint8)
    cv2.fillPoly(m, [np.array([[x * W, y * H] for x, y in pts], np.int32)], 1)
    return m > 0

def run():
    meta = {}
    for name, d in SPEC.items():
        a = np.array(Image.open(P + d['src'] + '.png').convert('RGBA')); H, W = a.shape[:2]
        m = (a[:, :, 3] > 30) & poly_mask(W, H, d['poly'])
        if d.get('biggest', True):
            n, lab, st, _ = cv2.connectedComponentsWithStats(m.astype(np.uint8), 8)
            if n > 1: m = lab == 1 + np.argmax(st[1:, cv2.CC_STAT_AREA])
        # 邊緣羽化一點點，免得切口太硬
        soft = cv2.GaussianBlur(m.astype(np.float32), (3, 3), 0.7)
        out = a.copy(); out[:, :, 3] = (a[:, :, 3] * np.minimum(1, soft * 1.15)).astype(np.uint8)
        ys, xs = np.where(m); x0, x1, y0, y1 = max(0, xs.min() - 3), min(W, xs.max() + 4), max(0, ys.min() - 3), min(H, ys.max() + 4)
        Image.fromarray(out[y0:y1, x0:x1]).save(P + name + '.png')
        meta[name] = [int(x1 - x0), int(y1 - y0)]
    print(json.dumps(meta))

if __name__ == '__main__':
    run()
