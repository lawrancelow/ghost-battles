# 從已拆好的手（cut/<id>__arm.png）再拆出一小塊（例如餓鬼王手上的包子），全部是原圖像素，不重畫。
# 用法：python3 cutpiece.py <id> [id...]   （規格寫在 limbs.json 的 "pieces"）
# 每一塊輸出 cut/<id>__<名字>.png，畫布大小和原圖一樣（座標直接沿用原圖比例）
#   "from":  "arm" | "orig" | "body"     從哪張圖拆
#   "box":   [x0,y0,x1,y1]               只在這個框裡找（原圖比例）
#   "skin":  [y起點, g-r 門檻, 外擴px]    把膚色（綠色手指）連同描邊排除：手指擋在前面的地方不要
#   "mirror":[軸x, y起點, 補洞外擴]       被手指擋住的缺口：用左右鏡射的同一顆包子補（原圖像素搬過來）
#   "erase": [[x0,y0,x1,y1], ...]         擦掉的碎邊
#   "minus": "<另一塊>"                   例如空手 = 手 − 包子
#   "biggest": true                       只留最大一塊（清掉碎屑）
import sys, json
import numpy as np, cv2
from PIL import Image
P = '/home/claude/gb/art/'
spec = json.load(open(P + 'limbs.json'))

def run(id):
    S = spec[id]; masks = {}
    for name, d in S.get('pieces', {}).items():
        src = {'arm': f'cut/{id}__arm.png', 'orig': f'cut/{id}.png', 'body': f'cut/{id}__body.png'}[d.get('from', 'arm')]
        a = np.array(Image.open(P + src).convert('RGBA')); H, W = a.shape[:2]; A = a.astype(int)
        yy, xx = np.mgrid[0:H, 0:W]
        m = A[:, :, 3] > 40
        if 'box' in d:
            x0, y0, x1, y1 = d['box']; m &= (xx >= x0 * W) & (xx < x1 * W) & (yy >= y0 * H) & (yy < y1 * H)
        if 'skin' in d:
            y0, thr, dil = d['skin']
            sk = (A[:, :, 3] > 40) & ((A[:, :, 1] - A[:, :, 0]) >= thr) & (yy > y0 * H)
            sk = cv2.morphologyEx(sk.astype(np.uint8), cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
            m &= ~(cv2.dilate(sk, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (dil, dil))) > 0)
        if 'minus' in d:
            m &= ~(cv2.dilate(masks[d['minus']].astype(np.uint8), np.ones((3, 3), np.uint8)) > 0)
        if d.get('biggest', True):
            n, lab, st, _ = cv2.connectedComponentsWithStats(m.astype(np.uint8), 8)
            if n > 1: m = lab == 1 + np.argmax(st[1:, cv2.CC_STAT_AREA])
        masks[name] = m
        out = a.copy(); out[:, :, 3] = (a[:, :, 3] * m).astype(np.uint8)
        if 'mirror' in d:  # 缺口用鏡射那一側的原圖補
            cx, y0, dil = d['mirror']; cx *= W
            mx = np.clip((2 * cx - xx).round().astype(int), 0, W - 1)
            mb = m[yy, mx]
            hole = mb & ~m
            fr = (cv2.dilate(hole.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (dil, dil))) > 0) & mb & (yy > y0 * H) & (xx < cx)
            mir = a[yy, mx]; mir[:, :, 3] = (mir[:, :, 3] * mb).astype(np.uint8)
            out[fr] = mir[fr]
        for x0, y0, x1, y1 in d.get('erase', []):
            out[(xx >= x0 * W) & (xx < x1 * W) & (yy >= y0 * H) & (yy < y1 * H), 3] = 0
        Image.fromarray(out).save(P + f'cut/{id}__{name}.png')
        ys, xs = np.where(out[:, :, 3] > 60)
        print(id, name, 'center', round(float(xs.mean() / W), 4), round(float(ys.mean() / H), 4), 'bbox', [round(float(v), 4) for v in (xs.min() / W, ys.min() / H, xs.max() / W, ys.max() / H)])

for id in sys.argv[1:]: run(id)
