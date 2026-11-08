# 冥街／回陽間「平日動作」用的拆件（daily_town.js 用）：全部從原圖切／搬，不重畫。
# 用法：python3 cuttown.py [ken] [boss] [guard] [auntie]（不給參數 = 全部）；之後 python3 pack.py 打包
# 輸出（整張原圖大小、同位置）：
#   npc_ken__fore.png   阿Ken 右手前臂＋手（手錶那隻，原本按著手機），繞手肘轉
#   npc_ken__bodyF.png  拿走前臂之後的身體：胸口用旁邊同一件襯衫的原圖搬過來補，掛繩照原圖那一段順著方向接下去
#   npc_boss__bodyN.png 陳總兩手都拿走的身體（= __body 的水晶球手已補 ＋ __bodyP 補好的手套手那塊）
#   npc_guard__bodyN.png 保安阿伯兩手都拿走（= __body 手電筒手已補 ＋ __bodyC 補好的保溫瓶手那塊）
#   street_strainer.png 宵夜檔背景上掛著的漏勺（從 bg/street.png 切出，給餓鬼王撈麵）
#   street_bowl.png     宵夜檔背景上的一個碗（最上面那個）
import sys
import numpy as np, cv2
from PIL import Image, ImageDraw, ImageFilter
P = '/home/claude/gb/art/'
C = P + 'cut/'
PREV = '/tmp/claude-0/-home-claude/acd4bce3-710a-5f1e-b171-7694b18c1d07/scratchpad/'

def poly_mask(pts, W, H, blur=1.2):
    m = Image.new('L', (W, H), 0); ImageDraw.Draw(m).polygon([(x * W, y * H) for x, y in pts], fill=255)
    if blur: m = m.filter(ImageFilter.GaussianBlur(blur))
    return np.array(m).astype(np.float32) / 255

def load(n): return np.array(Image.open(C + n).convert('RGBA'))
def save(a, n): Image.fromarray(a.astype(np.uint8)).save(C + n)

def grain(rgb, mask, seed, amp=7):
    rng = np.random.default_rng(seed); n = rng.normal(0, amp, mask.shape)
    n = cv2.GaussianBlur(n.astype(np.float32), (0, 0), 0.7)
    k = mask[..., None]
    return np.clip(rgb + n[..., None] * k, 0, 255)

def tile(fill, k, a, box, seed=0, base=None):
    # 用原圖上一塊乾淨的布料（box），鏡射來回鋪滿 k 的範圍。base 給了：只借布料的紋理（高頻），顏色深淺用 base（周圍的平均色）
    H, W = a.shape[:2]; x0, y0, x1, y1 = int(box[0] * W), int(box[1] * H), int(box[2] * W), int(box[3] * H)
    yy, xx = np.mgrid[0:H, 0:W]; lw, lh = x1 - x0, y1 - y0
    qx = np.mod(xx + seed, 2 * lw); qx = np.where(qx >= lw, 2 * lw - 1 - qx, qx)
    qy = np.mod(yy + seed // 2, 2 * lh); qy = np.where(qy >= lh, 2 * lh - 1 - qy, qy)
    src = a[y0 + qy, x0 + qx, :3].astype(np.float32)
    if base is not None:
        sw = a[y0:y1, x0:x1, :3].astype(np.float32); mean = sw.reshape(-1, 3).mean(0)
        lo = cv2.GaussianBlur(np.ascontiguousarray(src), (0, 0), 5)
        src = base + (src - lo)
    for c in range(3): fill[:, :, c] = fill[:, :, c] * (1 - k) + src[:, :, c] * k

def smooth_base(a, hole, sigma=14, region=None, blue=None):
    # 洞裡的底色：只拿周圍「不是描邊」的像素做加權模糊（描邊不會被抹進來）
    rgb = a[:, :, :3].astype(np.float32); lum = rgb.sum(2)
    v = ((a[:, :, 3] > 200) & (lum > 330) & (hole == 0)).astype(np.float32)
    if blue is not None: v *= ((rgb[:, :, 2] - rgb[:, :, 0]) > 12) if blue else ((rgb[:, :, 0] - rgb[:, :, 2]) > 12)
    if region is not None: v *= region
    out = None
    for sg in (sigma * 8, sigma * 4, sigma * 2, sigma):  # 大的先墊底，越近的越優先（大洞中間也有顏色）
        num = cv2.GaussianBlur(rgb * v[..., None], (0, 0), sg); den = cv2.GaussianBlur(v, (0, 0), sg)[..., None]
        b = num / np.maximum(den, 1e-6)
        if out is None: out = b
        else: w = np.clip(den / 0.25, 0, 1); out = out * (1 - w) + b * w
    return out

def strip(fill, a, P1, P2, S1, S2, hw, k_lim=None):
    # 把原圖上看得到的一小段帶子（S1→S2）沿 P1→P2 來回鋪（掛繩）
    H, W = a.shape[:2]
    P1, P2, S1, S2 = [np.array([p[0] * W, p[1] * H]) for p in (P1, P2, S1, S2)]
    L = np.linalg.norm(P2 - P1); d = (P2 - P1) / L; n = np.array([-d[1], d[0]])
    Ls = np.linalg.norm(S2 - S1); ds = (S2 - S1) / Ls; ns = np.array([-ds[1], ds[0]])
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    t = (xx - P1[0]) * d[0] + (yy - P1[1]) * d[1]; u = (xx - P1[0]) * n[0] + (yy - P1[1]) * n[1]
    q = np.mod(t, 2 * Ls); q = np.where(q > Ls, 2 * Ls - q, q)
    mx = (S1[0] + q * ds[0] + u * ns[0]).astype(np.float32); my = (S1[1] + q * ds[1] + u * ns[1]).astype(np.float32)
    src = cv2.remap(np.ascontiguousarray(a), mx, my, cv2.INTER_LINEAR).astype(np.float32)
    k = ((t >= -2) & (t <= L + 2)).astype(np.float32) * np.clip(hw - np.abs(u) + 0.5, 0, 1)
    if k_lim is not None: k *= k_lim
    for c in range(3): fill[:, :, c] = fill[:, :, c] * (1 - k) + src[:, :, c] * k

def ken():
    a = load('npc_ken.png'); H, W = a.shape[:2]
    fore = [(0.232, 0.47), (0.262, 0.452), (0.30, 0.44), (0.35, 0.438), (0.392, 0.446), (0.425, 0.465), (0.447, 0.486),
            (0.52, 0.494), (0.60, 0.503), (0.66, 0.52), (0.72, 0.538), (0.748, 0.545), (0.766, 0.556),
            (0.768, 0.578), (0.75, 0.596), (0.72, 0.606), (0.66, 0.611), (0.58, 0.605), (0.50, 0.591), (0.445, 0.574), (0.415, 0.56), (0.40, 0.553),
            (0.35, 0.551), (0.30, 0.549), (0.26, 0.543), (0.236, 0.526)]
    M = poly_mask(fore, W, H, 1.0)
    # 外擴一圈：手的描邊壓在襯衫上的那幾像素，算手的（只拿深色描邊，不拿襯衫）
    Mb = cv2.GaussianBlur(cv2.dilate((M > 0.3).astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15, 15))).astype(np.float32), (5, 5), 0)
    Ms = cv2.GaussianBlur(cv2.dilate((M > 0.3).astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (9, 9))).astype(np.float32), (3, 3), 0)
    af = a[:, :, :3].astype(np.float32); dark = ((af.sum(2) < 260) & (af[:, :, 2] - af[:, :, 0] < 6)).astype(np.float32)
    dark = cv2.GaussianBlur(cv2.dilate(dark.astype(np.uint8), np.ones((3, 3), np.uint8)).astype(np.float32), (3, 3), 0)
    MA = np.clip(M + (Ms - M).clip(0) * dark * poly_mask([(0, 0), (0.6, 0), (0.6, 0.53), (0.8, 0.56), (0.8, 1), (0, 1)], W, H, 1), 0, 1)
    arm = a.copy(); arm[:, :, 3] = (a[:, :, 3] * MA).astype(np.uint8)
    M = Mb
    keepL = poly_mask([(0, 0), (0.247, 0), (0.247, 1), (0, 1)], W, H, 0.8)  # 左手（另一隻）的右邊描邊留在身體上
    holeM = M * (1 - keepL)
    hole = (holeM > 0.02).astype(np.uint8)
    rgb = cv2.cvtColor(np.ascontiguousarray(a[:, :, :3]), cv2.COLOR_RGB2BGR)
    fill = cv2.cvtColor(cv2.inpaint(rgb, hole * 255, 9, cv2.INPAINT_TELEA), cv2.COLOR_BGR2RGB).astype(np.float32)
    # 襯衫：用下面一塊乾淨的襯衫（名牌右邊、下擺上面）鏡射鋪滿；袖口下面靠袋子那邊留給模糊補色
    shirt = poly_mask([(0.24, 0.42), (0.715, 0.42), (0.705, 0.64), (0.24, 0.64)], W, H, 2.5) * hole
    bag = poly_mask([(0.715, 0.50), (0.83, 0.50), (0.83, 0.64), (0.705, 0.64)], W, H, 2.5) * hole
    shirtRegion = poly_mask([(0.10, 0.36), (0.70, 0.36), (0.69, 0.66), (0.10, 0.66)], W, H, 0)
    tile(fill, shirt, a, (0.45, 0.61, 0.55, 0.635), 7, smooth_base(a, hole, 16, shirtRegion, True))
    tile(fill, bag, a, (0.74, 0.585, 0.83, 0.62), 3, smooth_base(a, hole, 10, poly_mask([(0.70, 0.45), (0.95, 0.45), (0.95, 0.68), (0.70, 0.68)], W, H, 0), False))
    # 掛繩：右邊那條（看得到的上段）往下接到夾子；左邊那條從領口接到夾子（用右邊那條的紋理）
    hv = hole.astype(np.float32)
    strip(fill, a, (0.437, 0.47), (0.393, 0.556), (0.458, 0.432), (0.434, 0.484), 0.0155 * W, hv)
    strip(fill, a, (0.300, 0.43), (0.362, 0.556), (0.458, 0.432), (0.434, 0.484), 0.0155 * W, hv)
    # 襯衫和袋子之間：補一條原圖色的描邊（接上袋子原本的左邊線）
    ln = Image.new('L', (W, H), 0); ImageDraw.Draw(ln).line([(0.703 * W, 0.528 * H), (0.700 * W, 0.58 * H), (0.692 * W, 0.632 * H)], fill=255, width=7)
    ln = np.array(ln.filter(ImageFilter.GaussianBlur(1.0))).astype(np.float32) / 255 * hv
    dk = np.median(a[(a[:, :, :3].sum(2) < 200) & (a[:, :, 3] > 250)][:, :3], axis=0)
    for c in range(3): fill[:, :, c] = fill[:, :, c] * (1 - ln) + dk[c] * ln
    fill = grain(fill, hv, 5, 4)
    body = a.astype(np.float32).copy()
    hb = cv2.GaussianBlur(hv, (3, 3), 0)
    for c in range(3): body[:, :, c] = body[:, :, c] * (1 - hb) + fill[:, :, c] * hb
    save(arm, 'npc_ken__fore.png'); save(body, 'npc_ken__bodyF.png')
    prev([a, arm, body], 'cut_ken.png', crop=(0, 0.3, 1, 0.75))

def combine(base, other, piece, out, dil=9):
    # base = 拿走 A 手的身體；other = 拿走 B 手的身體（B 那塊已補好）；piece = B 手。B 手範圍（外擴）內用 other 的像素
    b = load(base).astype(np.float32); o = load(other).astype(np.float32); p = load(piece)
    m = (p[:, :, 3] > 10).astype(np.uint8)
    m = cv2.dilate(m, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (dil, dil)))
    # 只在 other 跟原圖不一樣的地方（被補過、被擦掉的）換
    k = cv2.GaussianBlur(m.astype(np.float32), (5, 5), 0)
    r = b * (1 - k[..., None]) + o * k[..., None]
    save(r, out); return r

def boss():
    r = combine('npc_boss__body.png', 'npc_boss__bodyP.png', 'npc_boss__point.png', 'npc_boss__bodyN.png')
    prev([load('npc_boss.png'), r], 'cut_boss.png')

def guard():
    r = combine('npc_guard__body.png', 'npc_guard__bodyC.png', 'npc_guard__club.png', 'npc_guard__bodyN.png')
    # 肩膀外面那一小塊殘渣（袖子的接口）擦掉——袖子會蓋住；轉開的時候才不會露
    H0, W0 = r.shape[:2]
    r[:, :, 3] *= 1 - poly_mask([(0.915, 0.37), (1, 0.37), (1, 0.62), (0.915, 0.62)], W0, H0, 0.8) - poly_mask([(0.95, 0.72), (1, 0.72), (1, 0.92), (0.95, 0.92)], W0, H0, 0.8)
    save(r, 'npc_guard__bodyN.png')
    # 保溫瓶那隻手再拆兩段：袖子（繞肩）、手＋保溫瓶（繞手腕），袖口的描邊留在袖子上（蓋住手腕的接口）
    c = load('npc_guard__club.png'); H, W = c.shape[:2]
    sl = poly_mask([(0.84, 0.39), (0.90, 0.39), (1.0, 0.48), (1.0, 0.566), (0.955, 0.556), (0.90, 0.566), (0.862, 0.574), (0.842, 0.574), (0.838, 0.52), (0.836, 0.45)], W, H, 0.8)
    a1 = c.copy(); a1[:, :, 3] = (c[:, :, 3] * sl).astype(np.uint8)
    a2 = c.copy(); a2[:, :, 3] = (c[:, :, 3] * (1 - sl)).astype(np.uint8)
    save(a1, 'npc_guard__sleeve.png'); save(a2, 'npc_guard__tea.png')
    prev([load('npc_guard.png'), r, a1, a2], 'cut_guard.png', crop=(0.55, 0.3, 1.0, 0.8))

def strip_rgba(img, P1, P2, S1, S2, hw):
    # 帶子／桿子：原圖看得到的一段（S1→S2）沿 P1→P2 來回鋪（RGBA，只補原本透明或被擋住的地方）
    H, W = img.shape[:2]
    P1, P2, S1, S2 = [np.array([p[0] * W, p[1] * H]) for p in (P1, P2, S1, S2)]
    L = np.linalg.norm(P2 - P1); d = (P2 - P1) / L; n = np.array([-d[1], d[0]])
    Ls = np.linalg.norm(S2 - S1); ds = (S2 - S1) / Ls; ns = np.array([-ds[1], ds[0]])
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    t = (xx - P1[0]) * d[0] + (yy - P1[1]) * d[1]; u = (xx - P1[0]) * n[0] + (yy - P1[1]) * n[1]
    q = np.mod(t, 2 * Ls); q = np.where(q > Ls, 2 * Ls - q, q)
    mx = (S1[0] + q * ds[0] + u * ns[0]).astype(np.float32); my = (S1[1] + q * ds[1] + u * ns[1]).astype(np.float32)
    src = cv2.remap(np.ascontiguousarray(img), mx, my, cv2.INTER_LINEAR).astype(np.float32)
    k = ((t >= 0) & (t <= L)).astype(np.float32) * np.clip(hw - np.abs(u) + 0.5, 0, 1) * (src[:, :, 3] / 255)
    out = img.astype(np.float32)
    for ch in range(3): out[:, :, ch] = out[:, :, ch] * (1 - k) + src[:, :, ch] * k
    out[:, :, 3] = np.maximum(out[:, :, 3] * (1 - k), src[:, :, 3] * k)
    return out

def auntie():
    # 拖把（整支，被拳頭擋住的那段桿子用下面看得到的桿子接回去）＋ 拳頭
    a = load('npc_auntie__arm.png'); H, W = a.shape[:2]
    fist = [(0.222, 0.476), (0.25, 0.452), (0.30, 0.445), (0.338, 0.46), (0.35, 0.50), (0.338, 0.548), (0.30, 0.568), (0.262, 0.568), (0.232, 0.542)]
    F = poly_mask(fist, W, H, 0.8)
    f = a.copy(); f[:, :, 3] = (a[:, :, 3] * F).astype(np.uint8)
    m = a.copy(); m[:, :, 3] = (a[:, :, 3] * (1 - F)).astype(np.uint8)
    m = strip_rgba(m, (0.258, 0.425), (0.300, 0.64), (0.303, 0.65), (0.3155, 0.73), 0.0275 * W)
    # 拳頭周圍：不是桿子的碎描邊擦掉
    Fd = cv2.dilate((F > 0.3).astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (17, 17))).astype(np.float32)
    band = Image.new('L', (W, H), 0); ImageDraw.Draw(band).line([(0.258 * W, 0.425 * H), (0.303 * W, 0.65 * H)], fill=255, width=int(0.058 * W))
    band = np.array(band.filter(ImageFilter.GaussianBlur(0.8))).astype(np.float32) / 255
    m[:, :, 3] = m[:, :, 3] * (1 - Fd * (1 - band) * (np.arange(H)[:, None] > 0.44 * H) * (np.arange(W)[None, :] > 0.215 * W))
    # 桿子上兩顆白點（原本切的時候帶到的圍裙）擦掉
    m[:, :, 3] = (m[:, :, 3] * (1 - poly_mask([(0.325, 0.735), (0.37, 0.735), (0.37, 0.775), (0.325, 0.775)], W, H, 0.5) * (m[:, :, :3].astype(int).sum(2) > 600))).astype(np.uint8)
    al = (m[:, :, 3] > 40).astype(np.uint8); n, lab, st, _ = cv2.connectedComponentsWithStats(al, 8)
    if n > 2: keep = 1 + np.argmax(st[1:, cv2.CC_STAT_AREA]); m[:, :, 3] = m[:, :, 3] * (lab == keep)
    save(f, 'npc_auntie__fist.png'); save(m, 'npc_auntie__mop.png')
    prev([a, m, f], 'cut_auntie.png', crop=(0, 0.15, 0.5, 1.0))

def street():
    im = np.array(Image.open(P + 'bg/street.png').convert('RGBA')); H, W = im.shape[:2]
    def cut(box, shapes, out):
        x0, y0, x1, y1 = [int(v) for v in (box[0] * W, box[1] * H, box[2] * W, box[3] * H)]
        c = im[y0:y1, x0:x1].copy(); h, w = c.shape[:2]
        m = Image.new('L', (w, h), 0); d = ImageDraw.Draw(m)
        for s in shapes:
            if s[0] == 'el': d.ellipse([s[1] * w, s[2] * h, s[3] * w, s[4] * h], fill=255)
            if s[0] == 'poly': d.polygon([(x * w, y * h) for x, y in s[1]], fill=255)
        m = np.array(m.filter(ImageFilter.GaussianBlur(0.8))).astype(np.float32) / 255
        c[:, :, 3] = (m * 255).astype(np.uint8); Image.fromarray(c).save(C + out); return c
    # 漏勺：圓（連一圈深色邊）＋細柄
    x0, y0, x1, y1 = 1088, 492, 1131, 570; w, h = x1 - x0, y1 - y0
    cut((x0 / W, y0 / H, x1 / W, y1 / H), [['el', 3.4 / w, 38.7 / h, 39.4 / w, 74.7 / h], ['poly', [(18 / w, 4 / h), (21.5 / w, 1 / h), (25 / w, 4 / h), (25 / w, 42 / h), (18 / w, 42 / h)]]], 'street_strainer.png')
    # 燈籠（白、紅）：上蓋 + 燈身（連深色邊）+ 下蓋 + 流蘇
    def lan(ox, oy, cx, cy, rx, ry, out):
        w, h = 80, 105
        sh = [['el', (cx - rx) / w, (cy - ry) / h, (cx + rx) / w, (cy + ry) / h],
              ['poly', [((cx - 11) / w, 9 / h), ((cx + 11) / w, 9 / h), ((cx + 11) / w, (cy - ry + 6) / h), ((cx - 11) / w, (cy - ry + 6) / h)]],
              ['poly', [((cx - 9) / w, (cy + ry - 6) / h), ((cx + 9) / w, (cy + ry - 6) / h), ((cx + 9) / w, (cy + ry + 10) / h), ((cx - 9) / w, (cy + ry + 10) / h)]],
              ['poly', [((cx - 4) / w, (cy + ry + 8) / h), ((cx + 4) / w, (cy + ry + 8) / h), ((cx + 6) / w, 104 / h), ((cx - 6) / w, 104 / h)]]]
        cut((ox / W, oy / H, (ox + w) / W, (oy + h) / H), sh, out)
    lan(1453, 289, 40, 41, 29, 31, 'street_lanternW.png')
    lan(725, 295, 40, 47, 32, 33, 'street_lanternR.png')
    prev([np.array(Image.open(C + f)) for f in ('street_strainer.png', 'street_lanternW.png', 'street_lanternR.png')], 'cut_strainer.png')

def prev(ims, name, crop=None):
    H = 420; row = []
    for im in ims:
        im = Image.fromarray(im.astype(np.uint8))
        if crop: w, h = im.size; im = im.crop((int(crop[0] * w), int(crop[1] * h), int(crop[2] * w), int(crop[3] * h)))
        im = im.resize((int(im.width * H / im.height), H)); bg = Image.new('RGBA', im.size, (110, 160, 110, 255)); bg.alpha_composite(im); row.append(bg)
    o = Image.new('RGBA', (sum(r.width + 6 for r in row), H), (255, 255, 255, 255)); x = 0
    for r in row: o.alpha_composite(r, (x, 0)); x += r.width + 6
    o.save(PREV + name)

if __name__ == '__main__':
    todo = sys.argv[1:] or ['ken', 'boss', 'guard', 'auntie', 'street']
    for t in todo: globals()[t]()
    print('ok', todo)
