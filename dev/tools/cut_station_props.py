# 陽間站崗障礙物切圖：gb_props_sheet.png（4×3，灰底）→ 透明 webp → src/station_props.js
# 做法：每格估灰底色 → 「物件核心」＝有彩度／明顯唔同灰底嘅像素，閉運算＋補洞（但大片灰底洞保留透明，例如手推車扶手中間）
#       核心外面嘅中性暗灰（陰影排線）用「黑色＋alpha」還原：alpha = (底亮度 − 像素亮度) / 底亮度，陰影邊緣自然柔和
import sys, io, base64, json
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

SRC = '/home/claude/gen_art/gb_props_sheet.png'
OUT_JS = '/home/claude/gb/src/station_props.js'
OUT_PREVIEW = '/tmp/claude-0/out/props_cut.png'
NAMES = [['boxes', 'trolley', 'stools', 'bin'], ['puddle', 'wire', 'moto', 'cones'], ['sign', 'durian', 'plant', 'table']]
ZH = {'boxes': '紙皮箱', 'trolley': '手推車', 'stools': '紅膠凳', 'bin': '垃圾桶', 'puddle': '水氹', 'wire': '斷電線', 'moto': '舊電單車',
      'cones': '雪糕筒＋封條', 'sign': '跌落招牌', 'durian': '榴槤箱', 'plant': '倒瀉盆栽', 'table': '爛摺枱'}
# 落地碰撞框：取物件核心最底嗰段（佔核心高度比例）做腳底；平放嘢（水氹、電線）幾乎成件都係地面
FOOT_DEPTH = {'boxes': 0.42, 'trolley': 0.45, 'stools': 0.22, 'bin': 0.30, 'puddle': 1.0, 'wire': 1.0, 'moto': 0.50, 'cones': 0.42,
              'sign': 0.45, 'durian': 0.45, 'plant': 0.55, 'table': 0.35}
MAXS = 256

im = np.asarray(Image.open(SRC).convert('RGB')).astype(np.float32)
H, W, _ = im.shape
cw, ch = W / 4, H / 3


def lum(a):
    return a[..., 0] * 0.299 + a[..., 1] * 0.587 + a[..., 2] * 0.114


def cut(cell):
    h, w, _ = cell.shape
    border = np.concatenate([cell[:6].reshape(-1, 3), cell[-6:].reshape(-1, 3), cell[:, :6].reshape(-1, 3), cell[:, -6:].reshape(-1, 3)])
    bg = np.median(border, 0)
    L, Lb = lum(cell), lum(bg[None, None])[0, 0]
    chroma = cell.max(2) - cell.min(2)
    d = np.abs(cell - bg).max(2)
    nearbg = d <= 9
    shadowish = (chroma <= 14) & (L < Lb) & (L > 38)       # 中性、比底暗 → 可能係陰影
    strong = ~nearbg & ~shadowish                            # 有色／好黑線／比底光 → 物件
    core = ndi.binary_closing(strong, iterations=2)
    lab, n = ndi.label(core)
    sizes = ndi.sum(core, lab, range(1, n + 1))
    core = np.isin(lab, 1 + np.where(sizes >= 25)[0])
    filled = ndi.binary_fill_holes(core)
    holes, nh = ndi.label(filled & ~core)
    for i in range(1, nh + 1):
        m = holes == i
        a = m.sum()
        bgfrac = (nearbg[m] | shadowish[m]).mean()
        # 大片灰底／陰影洞 = 透視位（扶手中間、枱腳之間）→ 唔補；細洞或者入面有色 → 物件本身（例如手推車金屬面）
        nb, cm, lm = nearbg[m].mean(), chroma[m].mean(), L[m].mean()
        # 實測：真透視位 nearbg≥0.2、彩度≈1–3；物件本身（手推車鐵面、水氹）nearbg≈0、彩度 4–10
        if a > 60 and bgfrac > 0.85 and (nb >= 0.15 or (cm < 2.0 and lm > 85)):
            continue
        core |= m
    core = ndi.binary_opening(core, iterations=1) | (core & strong)
    # alpha：核心 1；核心外用黑色還原陰影
    sh_a = np.clip((Lb - L) / Lb * 1.15, 0, 0.85)
    sh_a[nearbg] = np.clip((Lb - L[nearbg] - 3) / Lb * 1.15, 0, 0.85)  # 貼近底色嘅淡陰影：扣走 3 級雜訊
    # 陰影只保留貼近物件嗰啲（避免遠處雜訊）
    near = ndi.binary_dilation(core, iterations=40)
    sh_a[~near] = 0
    soft = ndi.gaussian_filter(core.astype(np.float32), 0.6)
    a_obj = np.where(core, 1.0, np.clip(soft * 1.4, 0, 1))
    alpha = np.maximum(a_obj, sh_a)
    # 顏色：核心＝原色；核心外＝按比例混黑（陰影）
    w_obj = np.where(alpha > 0, a_obj / np.maximum(alpha, 1e-6), 0)[..., None]
    rgb = cell * w_obj  # 陰影部分 → 黑
    alpha[alpha < 0.03] = 0
    rgba = np.dstack([np.clip(rgb, 0, 255), alpha * 255]).astype(np.uint8)
    ys, xs = np.where(alpha > 0.03)
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    pad = 2
    y0, x0 = max(0, y0 - pad), max(0, x0 - pad); y1, x1 = min(h, y1 + pad), min(w, x1 + pad)
    return rgba[y0:y1, x0:x1], core[y0:y1, x0:x1]


def foot_of(core, depth):
    ys, xs = np.where(core)
    cy0, cy1 = ys.min(), ys.max() + 1
    fy0 = int(cy1 - (cy1 - cy0) * depth)
    band = core[fy0:cy1]
    bx = np.where(band.any(0))[0]
    # 去頭去尾 4%（甩出去嘅碎屑唔計）
    cols = band.sum(0); cum = np.cumsum(cols) / cols.sum()
    fx0 = int(np.searchsorted(cum, 0.03)); fx1 = int(np.searchsorted(cum, 0.97)) + 1
    hh, ww = core.shape
    return [round(float(v), 3) for v in (fx0 / ww, fy0 / hh, (fx1 - fx0) / ww, (cy1 - fy0) / hh)]


out = {}
tiles = []
for r in range(3):
    for c in range(4):
        k = NAMES[r][c]
        x0, x1, y0, y1 = int(c * cw), int((c + 1) * cw), int(r * ch), int((r + 1) * ch)
        rgba, core = cut(im[y0:y1, x0:x1])
        img = Image.fromarray(rgba, 'RGBA')
        s = MAXS / max(img.size)
        nw, nh = max(1, round(img.size[0] * s)), max(1, round(img.size[1] * s))
        img = img.resize((nw, nh), Image.LANCZOS)
        coreS = np.asarray(Image.fromarray(core.astype(np.uint8) * 255).resize((nw, nh), Image.BILINEAR)) > 127
        buf = io.BytesIO(); img.save(buf, 'WEBP', quality=90, alpha_quality=100, method=6)
        out[k] = dict(src='data:image/webp;base64,' + base64.b64encode(buf.getvalue()).decode(), w=nw, h=nh, foot=foot_of(coreS, FOOT_DEPTH[k]))
        tiles.append((k, Image.open(io.BytesIO(buf.getvalue())).convert('RGBA'), out[k]['foot']))
        print(k, nw, nh, len(buf.getvalue()), out[k]['foot'])

lines = ['// ===================== 陽間站崗・障礙物 sprite（由 tools/cut_station_props.py 自動切圖生成，唔好手改）=====================',
         '// 來源：gen_art/gb_props_sheet.png（4×3 灰底）→ 自動去背（陰影保留做半透明黑），最長邊 256px 透明 webp。',
         '// w／h：圖片像素尺寸。foot：[x, y, w, h] 落地碰撞框，佔圖片闊高比例（0–1），按物件實際著地嗰段估。',
         'const STN_PROPS = {']
for k, v in out.items():
    lines.append(f"  // {ZH[k]}")
    lines.append(f"  {k}:{{ src:'{v['src']}', w:{v['w']}, h:{v['h']}, foot:{json.dumps(v['foot']).replace(' ', '')} }},")
lines.append('};')
open(OUT_JS, 'w').write('\n'.join(lines) + '\n')

# 總覽：深色底 + 碰撞框
from PIL import ImageDraw
T = 300
sheet = Image.new('RGBA', (T * 4, T * 3 + 0), (30, 32, 38, 255))
dr = ImageDraw.Draw(sheet)
for i, (k, t, f) in enumerate(tiles):
    cx, cy = (i % 4) * T, (i // 4) * T
    dr.rectangle([cx + 2, cy + 2, cx + T - 3, cy + T - 3], fill=(30, 32, 38) if (i + i // 4) % 2 else (52, 40, 34))
    ox, oy = cx + (T - t.size[0]) // 2, cy + (T - t.size[1]) // 2
    sheet.alpha_composite(t, (ox, oy))
    fx, fy, fw, fh = f
    dr.rectangle([ox + fx * t.size[0], oy + fy * t.size[1], ox + (fx + fw) * t.size[0], oy + (fy + fh) * t.size[1]], outline=(0, 255, 120), width=1)
    dr.text((cx + 6, cy + 4), k, fill=(255, 255, 255))
sheet.convert('RGB').save(OUT_PREVIEW)
print('ok', OUT_JS, OUT_PREVIEW)
