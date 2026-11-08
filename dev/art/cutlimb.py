# 從原圖拆出「會動的手」和「武器」（兩張分開，武器以後可以換），身體被擋住的地方自動補畫。
# 用法：python3 cutlimb.py <id> [id...]   （規格寫在 limbs.json）
# 形狀座標都是原圖比例（x 佔寬、y 佔高）：
#   ["seg", x1,y1, x2,y2, 寬]   粗線（棍、桿）
#   ["box", x0,y0, x1,y1]        方框（斧刃、叉頭）
#   ["circ", x,y, 半徑(佔寬)]    圓（拳頭）
#   ["poly", [[x,y],...]]        多邊形
#   ["minus", <形狀>]            從遮罩挖掉
# limbs.json 每個角色：shapes（手）、wshapes（武器，可省略）、pivot（握把/手腕，轉動中心）、tip（武器尖端）
# 輸出：cut/<id>__arm.png、cut/<id>__wpn.png（裁切後）、cut/<id>__body.png，以及 weapons.json（武器握把位置）
import sys, json, os
import numpy as np, cv2
from PIL import Image, ImageDraw, ImageFilter
P = '/home/claude/gb/art/'
spec = json.load(open(P + 'limbs.json'))
WJ = P + 'weapons.json'
weapons = json.load(open(WJ)) if os.path.exists(WJ) else {}

def mask(shapes, W, H):
    m = Image.new('L', (W, H), 0); d = ImageDraw.Draw(m)
    def one(sh, fill):
        k = sh[0]
        if k == 'seg':
            _, x1, y1, x2, y2, w = sh; d.line([(x1 * W, y1 * H), (x2 * W, y2 * H)], fill=fill, width=max(2, int(w * W)))
            for (x, y) in ((x1, y1), (x2, y2)): r = w * W / 2; d.ellipse([x * W - r, y * H - r, x * W + r, y * H + r], fill=fill)
        elif k == 'box': _, x0, y0, x1, y1 = sh; d.rectangle([x0 * W, y0 * H, x1 * W, y1 * H], fill=fill)
        elif k == 'circ': _, x, y, r = sh; r *= W; d.ellipse([x * W - r, y * H - r, x * W + r, y * H + r], fill=fill)
        elif k == 'poly': d.polygon([(x * W, y * H) for x, y in sh[1]], fill=fill)
        elif k == 'minus': one(sh[1], 0)
    for sh in shapes: one(sh, 255)
    return np.array(m.filter(ImageFilter.GaussianBlur(1.2))).astype(np.float32) / 255

def shaft(wpn, a, f, W, H):
    # f = [x1,y1, x2,y2（要補的一段）, sx1,sy1, sx2,sy2（原圖上看得到的一小段同一支桿，方向一致）, 半寬(佔高)]
    x1, y1, x2, y2, sx1, sy1, sx2, sy2, hw = f
    P1, P2, S1, S2 = (np.array([x1 * W, y1 * H]), np.array([x2 * W, y2 * H]), np.array([sx1 * W, sy1 * H]), np.array([sx2 * W, sy2 * H]))
    L = np.linalg.norm(P2 - P1); d = (P2 - P1) / L; n = np.array([-d[1], d[0]])
    Ls = np.linalg.norm(S2 - S1); ds = (S2 - S1) / Ls; ns = np.array([-ds[1], ds[0]]); hw *= H
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    t = (xx - P1[0]) * d[0] + (yy - P1[1]) * d[1]; u = (xx - P1[0]) * n[0] + (yy - P1[1]) * n[1]
    inside = (t >= 0) & (t <= L) & (np.abs(u) <= hw)
    q = np.mod(t, 2 * Ls); q = np.where(q > Ls, 2 * Ls - q, q)  # 來回鏡射鋪，不會有接縫
    mx = (S1[0] + q * ds[0] + u * ns[0]).astype(np.float32); my = (S1[1] + q * ds[1] + u * ns[1]).astype(np.float32)
    src = cv2.remap(np.ascontiguousarray(a), mx, my, cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
    sa = src[:, :, 3].astype(np.float32) / 255 * inside * np.clip((hw - np.abs(u)) + 0.5, 0, 1)
    da = wpn[:, :, 3].astype(np.float32) / 255
    k = sa * (1 - da)  # 只補在原本沒有的地方（看得到的原圖優先）
    for c in range(3): wpn[:, :, c] = (wpn[:, :, c] * (1 - k) + src[:, :, c] * k).astype(np.uint8)
    wpn[:, :, 3] = (np.clip(da + k, 0, 1) * 255).astype(np.uint8)

def run(id):
    S = spec[id]
    im = Image.open(P + f'cut/{id}.png').convert('RGBA'); W, H = im.size
    a = np.array(im)
    MA = mask(S['shapes'], W, H)
    if S.get('lum'):  # 手壓在深色頭髮上：只取亮的皮膚（再往外擴一點包住描邊），頭髮留在身體上 [亮度門檻, 外擴像素]
        thr, dil = S['lum']; lit = (cv2.cvtColor(np.ascontiguousarray(a[:, :, :3]), cv2.COLOR_RGB2GRAY) > thr).astype(np.uint8)
        lit = cv2.morphologyEx(lit, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
        lit = cv2.dilate(lit, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * dil + 1, 2 * dil + 1)))
        MA = MA * cv2.GaussianBlur(lit.astype(np.float32), (3, 3), 0)
    MW = mask(S['wshapes'], W, H) * (1 - MA) if S.get('wshapes') else np.zeros_like(MA)  # 手蓋在武器上：重疊處算手
    M = np.clip(MA + MW, 0, 1)
    arm = a.copy(); arm[:, :, 3] = (a[:, :, 3] * MA).astype(np.uint8)
    wpn = a.copy(); wpn[:, :, 3] = (a[:, :, 3] * MW).astype(np.uint8)
    body = a.copy(); body[:, :, 3] = (a[:, :, 3] * (1 - M)).astype(np.uint8)
    for f in S.get('wfill', []): shaft(wpn, a, f, W, H)  # 被擋住的一段桿子：照可見那段的樣子補畫成直桿
    if S.get('erase'): body[:, :, 3] = (body[:, :, 3] * (1 - mask(S['erase'], W, H))).astype(np.uint8)  # 身體上要擦掉的碎邊
    # 大塊被拿走的地方（例如捧在胸前的碗）：從原圖別處（donor 位移）搬一塊同材質的過來補
    patched = np.zeros((H, W), np.float32)
    for poly, ddx, ddy in S.get('patch', []):
        k = mask([['poly', poly]], W, H) * M
        sh = np.roll(np.roll(a, -int(round(ddy * H)), 0), -int(round(ddx * W)), 1).astype(np.float32)
        bf = body.astype(np.float32)
        for c in range(3): bf[:, :, c] = bf[:, :, c] * (1 - k) + sh[:, :, c] * k
        bf[:, :, 3] = bf[:, :, 3] * (1 - k) + sh[:, :, 3] * k
        body = bf.astype(np.uint8); patched = np.maximum(patched, k)
    # 被手擋住、其實在身體輪廓裡的地方：補畫
    keep = (body[:, :, 3] > 60).astype(np.uint8)
    ks = max(5, int(W * S.get('close', 0.07))) | 1
    closed = cv2.morphologyEx(keep, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (ks, ks)))
    hole = ((closed > 0) & (M > 0.3) & (a[:, :, 3] > 60) & (patched < 0.5)).astype(np.uint8)
    if S.get('holeclip'): hole = ((mask(S['holeclip'], W, H) > 0.5) & (M > 0.3) & (a[:, :, 3] > 60)).astype(np.uint8)  # 指定要補的範圍（手伸出身體外的部分不補；大洞也補得到）
    if hole.any() and not S.get('noinpaint'):
        rgb = cv2.cvtColor(np.ascontiguousarray(a[:, :, :3]), cv2.COLOR_RGB2BGR)
        fill = cv2.cvtColor(cv2.inpaint(rgb, (hole * 255).astype(np.uint8), 7, cv2.INPAINT_TELEA), cv2.COLOR_BGR2RGB)
        if S.get('fillfrom'):  # 洞補成旁邊一塊真的紋理（例如頭髮），比模糊補色自然 [dx, dy] 或多組 [[dx,dy],...]（佔寬、高，前面的優先）
            ff = S['fillfrom']; ff = ff if isinstance(ff[0], list) else [ff]
            src = body.copy()  # 從「拆掉手之後」的身體借，借不到手本身
            for fx, fy in reversed(ff):
                tex = cv2.warpAffine(np.ascontiguousarray(src), np.float32([[1, 0, fx * W], [0, 1, fy * H]]), (W, H), flags=cv2.WARP_INVERSE_MAP | cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
                ta = (tex[:, :, 3:4].astype(np.float32) / 255) ** 2  # 借來的那塊是透明的地方，還是用模糊補色
                fill = (tex[:, :, :3] * ta + fill * (1 - ta)).astype(np.uint8)
        hb = cv2.GaussianBlur(hole.astype(np.float32), (5, 5), 0)
        for c in range(3): body[:, :, c] = (body[:, :, c] * (1 - hb) + fill[:, :, c] * hb).astype(np.uint8)
        body[:, :, 3] = np.maximum(body[:, :, 3], (hb * 255).astype(np.uint8))
    # 清掉拆完剩下的小碎屑（身體上孤立的小塊）
    al = (body[:, :, 3] > 30).astype(np.uint8); n, lab, st, _ = cv2.connectedComponentsWithStats(al, 8)
    big = st[1:, cv2.CC_STAT_AREA].max() if n > 1 else 0
    for i in range(1, n):
        if st[i, cv2.CC_STAT_AREA] < big * 0.004: body[lab == i, 3] = 0
    Image.fromarray(arm).save(P + f'cut/{id}__arm.png'); Image.fromarray(body).save(P + f'cut/{id}__body.png')
    # 鐵鏈之類一節一節的武器：把最後幾節照原樣往下接長（[x0,y0,x1,y1 要複製的框, dx,dy 每次位移, 次數]），接在原圖底下
    for x0_, y0_, x1_, y1_, ddx, ddy, nrep, *md in S.get('wextend', []):
        pad = int(abs(ddy) * H * nrep) + 4; wpn = np.pad(wpn, ((0, pad), (0, 0), (0, 0)))
        bx0, by0, bx1, by1 = int(x0_ * W), int(y0_ * H), int(x1_ * W), int(y1_ * H); blk = wpn[by0:by1, bx0:bx1].astype(np.float32)
        if len(md) > 1: blk[:, :, 3] *= mask([['poly', md[1]]], W, H)[by0:by1, bx0:bx1]  # 只複製這個多邊形裡的部分
        for r in range(1, int(nrep) + 1):
            ox, oy = int(round(ddx * W * r)), int(round(ddy * H * r))
            dst = wpn[by0 + oy:by1 + oy, bx0 + ox:bx1 + ox].astype(np.float32); da = dst[:, :, 3:] / 255; sa = blk[:, :, 3:] / 255 * (1 if md and md[0] == 'over' else (1 - da))  # 預設疊在下面；'over' 疊在上面（下一節穿過上一節）
            out = dst.copy(); out[:, :, :3] = dst[:, :, :3] * (1 - sa) + blk[:, :, :3] * sa; out[:, :, 3:] = np.clip(da + sa - da * sa * (1 if md and md[0] == 'over' else 0), 0, 1) * 255
            wpn[by0 + oy:by1 + oy, bx0 + ox:bx1 + ox] = out.astype(np.uint8)
    # 武器：裁切，記下握把在裁切圖裡的位置、長度（以角色身高為單位）
    if S.get('wshapes'):
        ys, xs = np.where(wpn[:, :, 3] > 20); x0, x1, y0, y1 = xs.min(), xs.max() + 1, ys.min(), ys.max() + 1
        Image.fromarray(wpn[y0:y1, x0:x1]).save(P + f'cut/{id}__wpn.png')
        gx, gy = S.get('grip', S['pivot'])[0] * W, S.get('grip', S['pivot'])[1] * H; tx, ty = S['tip'][0] * W, S['tip'][1] * H
        weapons[S.get('weapon', id)] = {'img': f'{id}__wpn', 'grip': [(gx - x0) / (x1 - x0), (gy - y0) / (y1 - y0)], 'tip': [(tx - x0) / (x1 - x0), (ty - y0) / (y1 - y0)],
                                        'h': (y1 - y0) / H, 'w': (x1 - x0) / H, 'ang': float(np.degrees(np.arctan2(tx - gx, -(ty - gy)))), 'from': id, 'name': S.get('wname', '')}
        if S.get('flex'): weapons[S.get('weapon', id)]['flex'] = S['flex']  # 軟武器（鐵鏈）：分幾段彎
        json.dump(weapons, open(WJ, 'w'), ensure_ascii=False, indent=1)
    # 預覽：手（紅點=轉動中心、綠點=尖端）｜武器｜身體
    bg = (90, 90, 90, 255); s = 360 / H
    def show(x):
        B = Image.new('RGBA', (W, H), bg); B.alpha_composite(Image.fromarray(x)); return B
    A = show(arm); A.alpha_composite(Image.fromarray(wpn)); dd = ImageDraw.Draw(A)
    for nm, col in (('pivot', (255, 60, 60)), ('grip', (255, 220, 0)), ('tip', (60, 255, 60))):
        if nm not in S: continue
        x, y = S[nm]; dd.ellipse([x * W - 9, y * H - 9, x * W + 9, y * H + 9], outline=col, width=5)
    panels = [A, show(wpn), show(body), show(a)]
    out = Image.new('RGB', ((int(W * s) + 6) * 4, 360), (30, 30, 30))
    for i, pnl in enumerate(panels): out.paste(pnl.convert('RGB').resize((int(W * s), 360)), (i * (int(W * s) + 6), 0))
    out.save(f'/tmp/claude-0/limb_{id}.png'); print(id, 'hole px', int(hole.sum()))

for id in sys.argv[1:]: run(id)
