# 新鬼 40 隻：專屬招式要用的原圖拆件（不重畫，只是從原圖剪下來）
# 用法：python3 n30cut.py [id...]（不給 = 全部）
# 規格：art/new30/cuts.json  { id: { 件名: { "poly": [[x,y],...]（原圖比例）, "keep": true（只拿來用、身體上不挖掉）},
#                                   "_fill": [[[x,y],...], ...]（挖掉之後身體要補的範圍，cv2 補色 + 外緣描邊）} }
# 輸出（跟原圖同大小、同位置，pack.py 的 LIMB 規則會自動打包、跟原圖同比例縮放）：
#   cut/n30_<id>__<件名>.png    拆下來的件
#   cut/n30_<id>__fill.png      挖掉之後的補丁（只有洞的地方）
# 遊戲裡：身體 = 原圖 − 件（destination-out）+ 補丁（n30_rigs.js 的 N30.body）
import sys, json, os
import numpy as np, cv2
from PIL import Image, ImageDraw, ImageFilter
P = '/home/claude/gb/art/'
SPEC = json.load(open(P + 'new30/cuts.json'))

def pmask(poly, W, H, blur=1.0):
    m = Image.new('L', (W, H), 0); ImageDraw.Draw(m).polygon([(x * W, y * H) for x, y in poly], fill=255)
    if blur: m = m.filter(ImageFilter.GaussianBlur(blur))
    return np.array(m).astype(np.float32) / 255

def run(id):
    S = SPEC[id]; nm = id if id.startswith('npc_') else 'n30_' + id; src = P + f'cut/{nm}.png'  # npc_ 開頭的（反派 NPC）直接用原名
    a = np.array(Image.open(src).convert('RGBA')); H, W = a.shape[:2]
    removed = np.zeros((H, W), np.float32)
    for name, d in S.items():
        if name.startswith('_'): continue
        if 'circ' in d: cx, cy, r = d['circ']; import math; d = dict(d, poly=[[cx + r * math.cos(a / 24 * 6.2832), cy + r * W / H * math.sin(a / 24 * 6.2832)] for a in range(24)])  # 圓：半徑佔寬
        m = pmask(d['poly'], W, H)
        pc = a.copy(); pc[:, :, 3] = (a[:, :, 3] * m).astype(np.uint8)
        Image.fromarray(pc).save(P + f'cut/{nm}__{name}.png')
        if not d.get('keep'): removed = np.maximum(removed, m)
        print(' piece', id, name)
    fp = P + f'cut/{nm}__fill.png'
    if not S.get('_fill'):
        if os.path.exists(fp): os.remove(fp)
        return
    F = np.zeros((H, W), np.float32)
    tex = None
    rgb = cv2.cvtColor(np.ascontiguousarray(a[:, :, :3]), cv2.COLOR_RGB2BGR)
    # 補色時只參考「拆完之後還在」的身體像素：把件那一塊也當成洞（不然會借到件本身的顏色）
    big = ((removed > 0.05) | (a[:, :, 3] < 40)).astype(np.uint8) * 255
    fill = cv2.cvtColor(cv2.inpaint(rgb, big, 11, cv2.INPAINT_TELEA), cv2.COLOR_BGR2RGB)
    yy, xx = np.mgrid[0:H, 0:W]
    for f in S['_fill']:
        if isinstance(f, list): f = {'poly': f}
        m = pmask(f['poly'], W, H, 0.6); F = np.maximum(F, m)
        if f.get('tile'):  # 從原圖一塊乾淨的同材質（衣服、頭髮）來回鏡射鋪滿（真的紋理，不是模糊色）
            x0, y0, x1, y1 = [int(round(v * (W if i % 2 == 0 else H))) for i, v in enumerate(f['tile'])]
            Lx, Ly = x1 - x0, y1 - y0
            qx = (xx - x0) % (2 * Lx); qx = np.where(qx >= Lx, 2 * Lx - 1 - qx, qx)
            qy = (yy - y0) % (2 * Ly); qy = np.where(qy >= Ly, 2 * Ly - 1 - qy, qy)
            t = a[y0 + qy, x0 + qx, :3]
            k = (m > 0.5)[:, :, None]
            fill = np.where(k, t, fill)
    hole = ((F > 0.5) & (removed > 0.3)).astype(np.uint8)
    # 補丁 alpha：洞的範圍（羽化一點）
    k = cv2.GaussianBlur(hole.astype(np.float32), (3, 3), 0) * (F > 0.05)
    out = np.zeros_like(a); out[:, :, :3] = fill; out[:, :, 3] = (np.clip(k, 0, 1) * 255).astype(np.uint8)
    # 外緣描邊：最後身體（原圖 − 件 + 補丁）的輪廓，落在補丁上的那一圈畫成原圖的深色描邊
    body_a = np.maximum(a[:, :, 3].astype(np.float32) / 255 * (1 - removed), k)
    solid = (body_a > 0.5).astype(np.uint8)
    r = max(2, int(round(W * 0.007)))
    inner = cv2.erode(solid, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * r + 1, 2 * r + 1)))
    edge = (solid > 0) & (inner == 0) & (hole > 0)
    dark = (a[:, :, :3].astype(int).sum(2) < 200) & (a[:, :, 3] > 200)
    col = np.median(a[dark][:, :3], axis=0) if dark.any() else np.array([50, 34, 30])
    e = cv2.GaussianBlur(edge.astype(np.float32), (3, 3), 0)
    rng = np.random.default_rng(5); n = rng.normal(0, 8, (H, W))
    for c in range(3): out[:, :, c] = (out[:, :, c] * (1 - e) + np.clip(col[c] + n, 0, 255) * e).astype(np.uint8)
    Image.fromarray(out).save(fp)
    # 檢查圖：原圖｜拆完的身體（身體疊在補丁上）
    bodyimg = a.copy(); bodyimg[:, :, 3] = (a[:, :, 3] * (1 - removed)).astype(np.uint8)
    comp = Image.alpha_composite(Image.fromarray(out), Image.fromarray(bodyimg))
    sheet = Image.new('RGBA', (W * 2, H), (200, 220, 200, 255))
    sheet.alpha_composite(Image.open(src).convert('RGBA'), (0, 0)); sheet.alpha_composite(comp, (W, 0))
    os.makedirs('/tmp/claude-0/n30/cut', exist_ok=True); sheet.convert('RGB').save(f'/tmp/claude-0/n30/cut/{id}.png')
    print(' fill', id)

for id in (sys.argv[1:] or list(SPEC)): run(id)
