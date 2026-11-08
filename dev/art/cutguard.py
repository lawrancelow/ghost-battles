# 保安阿伯 專屬招式（保溫瓶）用的拆件：全部從原圖 cut/npc_guard.png 切／搬，不重畫。
# 輸出（整張原圖大小、同位置，pack.py 自動打包）：
#   cut/npc_guard__club.png  拿保溫瓶那隻手：袖子（上半是以肩關節為圓心的圓弧，轉起來像球形關節，接口不會露）+ 前臂 + 手 + 保溫瓶
#   cut/npc_guard__bodyC.png 拿走那隻手之後的身體：被手擋住的那塊用原圖補——胸口口袋用左胸口袋鏡射（原圖右口袋露出的那段剛好對上），
#                            襯衫／皮帶／褲子用旁邊同一條原圖來回鋪，身體右側沿左側輪廓鏡射位置補一條原圖色的描邊
# 用法：python3 cutguard.py [preview]
import sys
import numpy as np, cv2
from PIL import Image
P = '/home/claude/gb/art/cut/'
a = np.array(Image.open(P + 'npc_guard.png').convert('RGBA')).astype(np.int32)
H, W = a.shape[:2]
AX = 257                     # 領帶中線（鏡射軸）
C, R = (381, 283), 27        # 肩關節圓心、半徑（= 招式的轉軸）
EDGE = 353                   # 身體右側輪廓（左側輪廓 x≈161 對領帶中線鏡射）
lum = a[:, :, :3].sum(2)
yy, xx = np.mgrid[0:H, 0:W]
disc = (xx - C[0]) ** 2 + (yy - C[1]) ** 2 <= R * R
alpha = a[:, :, 3] > 20

# ---------- 保溫瓶：描邊圍起來的幾段（瓶蓋、瓶身、瓶底）各自填滿，再往外擴一圈描邊 ----------
dark = (lum < 330) & alpha
free = (~dark & alpha).astype(np.uint8)
def flood(seeds, lim=None):
    m = np.zeros((H, W), bool)
    for sx, sy in seeds:
        im = free.copy()
        if lim is not None: im[~lim] = 0
        if not im[sy, sx]: print('seed on dark', sx, sy); continue
        n_, lab = cv2.connectedComponents(im, connectivity=4)
        m |= lab == lab[sy, sx]
    return m
def near_free(p):  # 種子點：附近找一個不是描邊的點
    x0, y0 = p
    for r in range(0, 8):
        for dy in range(-r, r + 1):
            for dx in range(-r, r + 1):
                if free[y0 + dy, x0 + dx]: return (x0 + dx, y0 + dy)
    return p
TH_SEEDS = [near_free(p) for p in [(325, 300), (325, 329), (318, 380), (315, 444), (340, 300)]]
thin = flood(TH_SEEDS, (xx >= 284) & (xx <= 356) & (yy >= 270) & (yy <= 470))
th = cv2.dilate(thin.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (17, 17))) > 0
th &= alpha & ((lum < 230) | thin)          # 擴出去的只能是描邊（深色），不能吃到襯衫
th &= (xx >= 284) & (yy <= 470) & ~((xx > 354) & ~disc)
# ---------- 手（袖子 + 前臂 + 手）：膚色、袖子白色各段，往外擴一圈描邊；上方以肩關節圓弧為界 ----------
AR_SEEDS = [near_free(p) for p in [(400, 322), (398, 352), (360, 392), (384, 388), (388, 300), (372, 275)]]
lim = (((xx >= 350) & ((yy >= C[1]) | disc)) | ((xx >= 326) & (yy >= 340))) & (yy <= 434)
arin = flood(AR_SEEDS, lim)
arm = cv2.dilate(arin.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (17, 17))) > 0
arm &= alpha & ((lum < 230) | arin) & lim
club = (th | arm | (disc & alpha))
k = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
club = cv2.morphologyEx(club.astype(np.uint8), cv2.MORPH_CLOSE, k) > 0
club &= alpha
# 補洞（保溫瓶身上深色顆粒）
ff = (~club).astype(np.uint8).copy(); msk = np.zeros((H + 2, W + 2), np.uint8); cv2.floodFill(ff, msk, (0, 0), 2)
club |= (ff == 1)

# ---------- 身體：挖掉手，再用原圖補 ----------
body = a.copy()
hole = cv2.dilate(club.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (9, 9))) > 0
hole |= (cv2.dilate(club.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15, 15))) > 0) & (xx < 312) & (yy < 405)
BELT0, BELT1 = 405, 439
# 身體右緣以外（肩關節圓、肩膀上緣除外）原本都是手：全部清掉
right = (xx > EDGE + 3) & (yy >= 262) & (yy <= 470) & ~disc & ~((yy < 290) & (xx < C[0] - R + 4) & ~hole)
body[right] = 0
fillm = hole & ~right & (yy >= 250)
rng = np.random.default_rng(7)
def tile2(m, x0, x1, y0, y1, ox=0, oy=0):  # 原圖 [x0,x1)×[y0,y1) 這塊二維來回鋪
    L, M = x1 - x0, y1 - y0
    qx = (xx - ox) % (2 * L); qx = np.where(qx < L, qx, 2 * L - 1 - qx)
    qy = (yy - oy) % (2 * M); qy = np.where(qy < M, qy, 2 * M - 1 - qy)
    T = a[y0 + qy, x0 + qx]; body[m] = T[m]
# 襯衫底：左胸口袋下面乾淨的一塊
PATCH = (206, 227, 362, 389)
pa = a[PATCH[2]:PATCH[3], PATCH[0]:PATCH[1]]; pl = pa[:, :, :3].sum(2); med = np.median(pa[pl > 520][:, :3], axis=0)
spk = pl < 520
a_clean = a.copy(); sub = a_clean[PATCH[2]:PATCH[3], PATCH[0]:PATCH[1]]
for c in range(3): sub[:, :, c][spk] = (med[c] + rng.normal(0, 6, spk.sum())).astype(np.int32)
a_orig = a; a = a_clean
# 襯衫：左胸對領帶中線鏡射過來（口袋、皺褶、身體左側的輪廓都對得上；往下 6px 對上原圖右口袋露出的那段）
DY = 6
MIR = np.zeros_like(a)
for x in range(W):
    # 線性對應（稍微壓 10%）：原圖右口袋露出的左邊線 x≈284 ↔ 左口袋右邊線 x≈223；身體右緣 353 ↔ 左緣 161
    sx = int(round(223 - (x - 284) * (223 - 161) / (EDGE - 284)))
    if 0 <= sx < W: MIR[DY:, x] = a[:-DY, sx]
a = a_orig
sm = fillm & (yy < BELT0)
body[sm] = MIR[sm]
# 左邊接回原圖的地方漸變（原圖領口陰影接得上）
dl = cv2.distanceTransform(sm.astype(np.uint8), cv2.DIST_L2, 5)
wl = np.clip(dl / 7, 0, 1); zone = sm & (xx < 312)
for c in range(3): body[:, :, c][zone] = (a[:, :, c][zone] * (1 - wl[zone]) + MIR[:, :, c][zone] * wl[zone]).astype(np.int32)
# 鏡射過來會帶到對講機天線、對講機頂：那一塊用周圍的襯衫補（inpaint），再加回原圖襯衫的蠟筆顆粒
bl = body[:, :, :3].sum(2)
keep = sm & (yy >= 362) & (xx >= 300) & (xx <= 340) & ((bl < 600) | (yy >= 390))
keep = cv2.dilate(keep.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))) > 0
keep &= sm & (yy >= 360)
# 每一列的顏色取原圖領帶右邊那條乾淨襯衫（x 277~287，同一列，保留原圖由上到下的明暗），加上顆粒
colr = np.array([np.median(a[y, 277:288, :3], axis=0) for y in range(H)], np.float32)
colr = cv2.GaussianBlur(colr[:, None, :], (1, 9), 0)[:, 0, :]
gy_, gx_ = np.where(keep)
gr = cv2.GaussianBlur(rng.normal(0, 1, (H, W)).astype(np.float32), (0, 0), 0.8) * 22
for c in range(3):
    body[gy_, gx_, c] = np.clip(colr[gy_, c] + gr[gy_, gx_], 0, 255).astype(np.int32)
# 皮帶：對講機和皮帶扣之間那段
tile2(fillm & (yy >= BELT0 - 2) & (yy < BELT1), 214, 234, BELT0 - 2, BELT1, 290, BELT0 - 2)
# 褲子：保溫瓶底下那段往上搬
SH = np.zeros_like(a); SH[:-34] = a[34:]
body[fillm & (yy >= BELT1)] = SH[fillm & (yy >= BELT1)]
body[fillm, 3] = 255
# 身體右緣描邊（原圖描邊色、約 7px、蠟筆抖動）
dk = dark & (lum < 200)
col = np.median(a[dk][:, :3], axis=0)
n = rng.normal(0, 9, (H, W))
wob = 1.2 * np.sin(yy / 9.0) + 0.8 * np.sin(yy / 4.3 + 1)
ex = EDGE + wob
edge = (np.abs(xx - ex) <= 3.6) & (yy >= 258) & (yy <= 470)
edge &= (body[:, :, 3] > 0) | (xx <= EDGE + 3)
for c in range(3): body[:, :, c][edge] = np.clip(col[c] + n[edge], 0, 255).astype(np.int32)
body[edge, 3] = 255
body[(xx > ex + 3.6) & (yy >= 240) & (yy <= 470)] = 0  # 手拿走後，身體右邊全部清掉
# 肩頭：身上留一顆圓的肩膀（襯衫色＋原圖描邊色的圓弧），手的袖口圓弧剛好蓋在上面；手轉開時露出來的是圓肩，不是缺口
dC = np.sqrt((xx - C[0]) ** 2 + (yy - C[1]) ** 2); R2 = R + 1
colr2 = np.array([np.median(a[y, 277:288, :3], axis=0) for y in range(H)], np.float32)
dB = np.sqrt((xx - C[0] + 3) ** 2 + (yy - C[1] - 6) ** 2)
ballf = (dB <= R - 4) & (xx > ex - 1) & alpha   # 只在原圖輪廓以內（手垂著時跟原圖一模一樣）
gr2 = cv2.GaussianBlur(rng.normal(0, 1, (H, W)).astype(np.float32), (0, 0), 0.8) * 20
shirt = np.median(a[366:390, 207:229, :3].reshape(-1, 3), axis=0)
shade = (0.97 - 0.12 * np.clip((yy - C[1] + R2) / (2 * R2), 0, 1))
for c in range(3): body[:, :, c][ballf] = np.clip(shirt[c] * shade[ballf] + gr2[ballf], 0, 255).astype(np.int32)
solid_ = (body[:, :, 3] > 0) | ballf
inner_ = cv2.erode(solid_.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (9, 9))) > 0
ringm = ballf & ~inner_
for c in range(3): body[:, :, c][ringm] = np.clip(col[c] + n[ringm], 0, 255).astype(np.int32)
body[ballf, 3] = 255  # 手拿走後，身體右邊（含肩關節那塊）全部清掉
# 襯衫靠邊一點陰影
shd = fillm & (yy < BELT0) & (xx > EDGE - 16) & ~edge
f = (0.9 + 0.1 * np.clip((ex - xx) / 16, 0, 1))
for c in range(3): body[:, :, c][shd] = (body[:, :, c][shd] * f[shd]).astype(np.int32)

# ---------- 手：圓弧切口補一條描邊（袖口接縫） ----------
cl = a.copy(); cl[~club] = 0
inner = cv2.erode(club.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (11, 11))) > 0
arc = club & ~inner & (yy < C[1] + 6) & ((xx - C[0]) ** 2 + (yy - C[1]) ** 2 >= (R - 5) ** 2) & (lum > 330)
for c in range(3): cl[:, :, c][arc] = np.clip(col[c] + n[arc], 0, 255).astype(np.int32)
Image.fromarray(cl.astype(np.uint8)).save(P + 'npc_guard__club.png')
Image.fromarray(np.clip(body, 0, 255).astype(np.uint8)).save(P + 'npc_guard__bodyC.png')
print('pivot', C[0] / W, C[1] / H, 'R', R)
if len(sys.argv) > 1:
    bg = (200, 200, 200, 255)
    out = Image.new('RGBA', (220 * 3, 260), bg)
    for i, im in enumerate([Image.fromarray(body.astype(np.uint8)), Image.fromarray(cl.astype(np.uint8)), Image.open(P + 'npc_guard.png').convert('RGBA')]):
        b = Image.new('RGBA', (W, H), bg); b.alpha_composite(im); out.paste(b.crop((212, 220, 432, 480)), (220 * i, 0))
    out.resize((out.width * 2, out.height * 2), Image.NEAREST).save('/tmp/claude-0/gw/cut.png')
    z = Image.new('RGBA', (300, 120), bg)
    for i, im in enumerate([Image.fromarray(body.astype(np.uint8)), Image.fromarray(cl.astype(np.uint8))]):
        b = Image.new('RGBA', (W, H), bg); b.alpha_composite(im); z.paste(b.crop((270, 240, 420, 360)) if i == 0 else b.crop((330, 240, 480, 360)), (150 * i, 0))
    z.resize((1200, 480), Image.NEAREST).save('/tmp/claude-0/gw/cutz.png')
