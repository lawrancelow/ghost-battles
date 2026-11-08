# 把獨立畫好的蠟筆道具圖（cut/tool_*.png）加進武器庫 weapons.json，之後任何角色都能拿
# grip＝握把（手握的位置，靠握柄下端）、tip＝沿握柄方向延伸到最上端；ang＝grip→tip 的角度（從正上方順時針，跟 cutlimb.py 一樣）
# h/w＝以角色身高為 1 的大小（420px 高的角色）
import json, os, glob, math
import numpy as np
from PIL import Image
P = '/home/claude/gb/art/'
WJ = P + 'weapons.json'
# 名稱、在角色身上的高度（佔身高）、握把在圖高的哪裡（由上往下的比例）、握柄方向取樣的兩行（由上往下比例）
SPEC = {
    'tool_axe':        ('伐木斧', 0.46, 0.86, (0.92, 0.62)),
    'tool_mallet':     ('木槌',   0.44, 0.86, (0.92, 0.62)),
    'tool_sickle':     ('鐮刀',   0.36, 0.86, (0.94, 0.66)),
    'tool_baiwu':      ('哭喪棒', 0.80, 0.80, (0.96, 0.62)),
    'tool_mamian':     ('方天戟', 0.92, 0.78, (0.96, 0.70)),
    'tool_niutou':     ('鋼叉',   0.92, 0.78, (0.96, 0.70)),
    'tool_npc_auntie': ('拖把',   0.78, 0.82, (0.96, 0.62)),
    'tool_npc_boss':   ('水晶球', 0.26, 0.92, None),
    'tool_npc_guard':  ('手電筒', 0.24, 0.85, None),
    'tool_npc_ken':    ('手機',   0.18, 0.80, None),
}
# 握柄不是直的道具：手動指定
FIX = {'tool_npc_guard': ((0.735, 0.86), (0.70, 0.30)), 'tool_npc_ken': ((0.50, 0.84), (0.30, 0.18))}
W8 = json.load(open(WJ)) if os.path.exists(WJ) else {}
for f in sorted(glob.glob(P + 'cut/tool_*.png')):
    id = os.path.basename(f)[:-4]
    nm, hh, gy, rows = SPEC.get(id, (id, 0.4, 0.85, (0.92, 0.62)))
    a = np.array(Image.open(f).convert('RGBA'))[:, :, 3] > 40; H, W = a.shape
    def cx(fy):  # 某一行不透明部分的中心
        xs = np.where(a[int(fy * (H - 1))])[0]; return xs.mean() / W if len(xs) else 0.5
    if rows:  # 握柄方向：兩行的中心連線，往上延伸到圖頂
        y1, y2 = rows; x1, x2 = cx(y1), cx(y2)
        k = (x2 - x1) / (y2 - y1)  # 每單位 y 的 x 變化（比例座標）
        gx = x1 + k * (gy - y1); ty = 0.03; tx = x1 + k * (ty - y1)
    else:  # 小道具：握底部中間，尖端＝頂部中間
        ys, xs = np.where(a); gx = xs[ys > H * gy].mean() / W if (ys > H * gy).any() else 0.5
        ty = 0.04; tx = xs[ys < H * 0.15].mean() / W
    if id in FIX: (gx, gy), (tx, ty) = FIX[id]
    ang = math.degrees(math.atan2((tx - gx) * W, -(ty - gy) * H))
    W8[id] = {'img': id, 'grip': [round(float(gx), 4), gy], 'tip': [round(float(tx), 4), ty], 'h': hh, 'w': round(hh * W / H, 4), 'ang': round(ang, 2), 'from': 'tool', 'name': nm}
    print(id, nm, W8[id])
json.dump(W8, open(WJ, 'w'), ensure_ascii=False, indent=1)
