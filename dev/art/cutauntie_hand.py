# 清潔安娣：握拖把的手原本只切了「拳頭」，手腕那一塊留在身體上 → 拳頭一動就跟手腕分家、手飄在空中。
# 改成：拳頭＋手腕＝一整隻手（npc_auntie__hand，繞袖口的手腕轉）；身體（npc_auntie__bodyM）擦掉手腕那塊和旁邊的碎描邊。
# 全部是原圖像素，只做切和擦。用法：python3 cutauntie_hand.py；之後 python3 pack.py
import numpy as np
from PIL import Image, ImageDraw
D = '/home/claude/gb/art/cut/'
o = np.array(Image.open(D + 'npc_auntie.png').convert('RGBA'))
fist = np.array(Image.open(D + 'npc_auntie__fist.png').convert('RGBA'))
body = np.array(Image.open(D + 'npc_auntie__bodyH.png').convert('RGBA'))
H, W = o.shape[:2]
def poly(pts):
    m = Image.new('L', (W, H), 0); ImageDraw.Draw(m).polygon(pts, fill=255); return np.array(m) > 0
# 手腕那塊（拳頭右邊、袖口左邊）：含它自己的外框
wrist = poly([(166, 300), (176, 293), (192, 292), (204, 297), (212, 306), (215, 320), (214, 336), (207, 348), (192, 355), (175, 352), (164, 340), (162, 320)])
hand = np.zeros_like(o)
hand[wrist] = o[wrist]
oi = o.astype(int); purple = (oi[..., 2] > oi[..., 1] + 15) & (oi[..., 0] > 120)
hand[wrist & purple & (np.arange(W)[None, :] > 195)] = 0   # 袖子的紫色不要
k = fist[..., 3] > hand[..., 3]; hand[k] = fist[k]
Image.fromarray(hand).save(D + 'npc_auntie__hand.png')
# 身體：手腕擦掉（袖口外框 x≥204 留著），拳頭留下的碎線／淡圈（x<172 那一片）也擦掉
b = body.copy()
er = wrist & (np.arange(W)[None, :] < 204)
er |= poly([(100, 235), (181, 235), (181, 289), (164, 300), (160, 362), (100, 362)])
er |= poly([(160, 349), (206, 349), (206, 360), (160, 360)])
bi = body.astype(int); skin = (bi[..., 0] > 190) & (bi[..., 1] > 130) & (bi[..., 2] < 170) & (bi[..., 0] - bi[..., 2] > 50)
er |= wrist & skin                                   # 袖口邊上剩的一條手腕皮膚
b[er] = 0
# 拖把桿以前從頭髮旁邊、腳邊經過：bodyH 留下的淺色桿子碎片和一條細線，也擦掉
bi2 = b.astype(int)
light = bi2[..., :3].sum(2) > 330
er2 = poly([(146, 168), (170, 168), (170, 242), (146, 242)]) & light
yy, xx = np.mgrid[0:H, 0:W]
lx = 179 + (yy - 405) * (206 - 179) / (595 - 405)
er2 |= (yy > 478) & (np.abs(xx - lx) < 7.5) & (xx < 212)
er2 |= poly([(170, 572), (205, 572), (205, 605), (170, 605)]) & (xx < 196)
er2 |= (yy > 398) & (yy <= 480) & (xx < lx + 2.5) & (xx > lx - 8) & light
b[er2] = 0
import cv2
al = (b[..., 3] > 30).astype(np.uint8); n, lab, st, _ = cv2.connectedComponentsWithStats(al, 8)
for i in range(1, n):
    if st[i, cv2.CC_STAT_AREA] < 60: b[lab == i] = 0   # 小碎點
# 被拖把桿擋住的地方本來沒有外框（桿子壓在上面）：切口補一條同色的蠟筆外框（往內 3px，沿用原圖外框的顏色＋顆粒）
zone0 = (poly([(140, 160), (172, 160), (172, 248), (140, 248)]) | poly([(160, 395), (216, 395), (216, 605), (160, 605)]) | poly([(168, 278), (204, 278), (204, 300), (168, 300)]))
b[zone0 & (b[..., 3] < 200)] = 0
al = (b[..., 3] > 30).astype(np.uint8); n, lab, st, _ = cv2.connectedComponentsWithStats(al, 8)
for i in range(1, n):
    if st[i, cv2.CC_STAT_AREA] < 80: b[lab == i] = 0
m = b[..., 3] > 128
inner = cv2.erode(m.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (7, 7))).astype(bool)
edge = m & ~inner
zone = (poly([(140, 160), (172, 160), (172, 248), (140, 248)]) | poly([(160, 395), (216, 395), (216, 605), (160, 605)]) | poly([(168, 278), (204, 278), (204, 300), (168, 300)]))
bi3 = b.astype(int); notdark = bi3[..., :3].sum(2) > 260
paint = edge & zone & notdark
rng = np.random.default_rng(3); noise = rng.integers(-12, 12, size=(H, W))
for ch, v in enumerate((62, 40, 34)): b[..., ch][paint] = np.clip(v + noise[paint], 0, 255)
b[..., 3][paint] = 255
Image.fromarray(b).save(D + 'npc_auntie__bodyM.png')
print('ok', hand[..., 3].astype(bool).sum(), er.sum())
