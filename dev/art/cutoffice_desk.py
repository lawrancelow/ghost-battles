# 從原圖 of_desk 拿掉內建的螢幕和杯子（之後用 op_mon_* / op_mug 單獨畫，才能動）
# 方法：桌面後緣以上 = 透明；被底座／杯底蓋住的桌面 = 從旁邊乾淨的桌面欄位（原圖像素）照桌緣高度對齊搬過來
import numpy as np
from PIL import Image
a = np.array(Image.open('/home/claude/gb/art/cut/of_desk.png').convert('RGBA'))
A = a.astype(int)
o = a.copy()
def dark(y, x): return A[y, x, 3] > 128 and A[y, x, :3].sum() < 330
def orange(y, x): r, g, b = A[y, x, :3]; return A[y, x, 3] > 128 and r > 150 and r - b > 50 and g > 100
def ytop(x):  # 桌面後緣外框線的上緣
    if x <= 300: return 122
    return round(120 + (x - 300) * (136 - 120) / 92)
REF = [c for c in range(266, 296)]
OT = {c: next(y for y in range(117, 140) if dark(y, c) and A[y - 1, c, 3] < 128) for c in REF}
def rebuild(x0, x1, stop):
    for i, x in enumerate(range(x0, x1)):
        yt = ytop(x); sp = stop(x)
        o[0:yt, x] = 0
        rc = REF[(i * 7) % len(REF)]
        for y in range(yt, sp):
            rel = y - yt
            while OT[rc] + rel > 146: rel -= 10
            o[y, x] = a[OT[rc] + rel, rc]
def first_orange(x, y0):
    for y in range(y0, 175):
        if orange(y, x): return y
    return y0
for x in range(126, 162):                          # 紙堆上緣以上（螢幕左下角壓在紙堆後面）
    o[0:112, x] = 0
    for y in range(112, 150):
        if A[y, x, :3].sum() > 600 or orange(y, x): break
        o[y, x] = 0
rebuild(162, 175, lambda x: first_orange(x, 128))
rebuild(175, 262, lambda x: first_orange(x, 146))  # 底座底下的桌面，到露出桌面為止
for x in range(262, 302): o[0:ytop(x), x] = 0
def orange2(y, x): r, g, b = A[y, x, :3]; return A[y, x, 3] > 128 and r > 200 and g > 130 and b < 150
def first_or2(x, y0):
    for y in range(y0, 175):
        if orange2(y, x) and orange2(y + 1, x): return y
    return y0
rebuild(302, 393, lambda x: first_or2(x, 140) if x >= 338 else 141)
for x in range(302, 340):                           # 杯底在滑鼠上面露出來的一點：淺色瓷 → 桌面
    for y in range(141, 150):
        r, g, b = A[y, x, :3]
        if A[y, x, 3] > 128 and min(r, g, b) > 150 and max(r, g, b) - min(r, g, b) < 60: o[y, x] = a[y + 6, x + 60]
Image.fromarray(o).save('/home/claude/gb/art/cut/of_desk_clean.png')
# 收尾：螢幕切掉後留下的孤立細線（5×5 內不到 8 個不透明的點）
o2 = o.copy(); al = o[..., 3] > 100
for y in range(90, 145):
    for x in range(120, 180):
        if al[y, x] and al[max(0, y - 2):y + 3, x - 2:x + 3].sum() < 12: o2[y, x] = 0
Image.fromarray(o2).save('/home/claude/gb/art/cut/of_desk_clean.png')
