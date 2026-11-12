# 陽間站崗 A／B 批美術切圖：
#  A. gen_art/gb_chibi_sheet2.png（4×3 灰底 Q 版：網紅組、探險組、4 個新路人）
#  B. gen_art/gb_vfx_sheet.png（4×2 灰底手繪特效）
# 去背：由邊界 flood fill 灰底（容許光暈），按同灰底色差做軟 alpha，再「反混色」還原光暈顏色，冇灰邊。
# 輸出：art/cut_stn_ab/*.webp(+png 預覽) 同 src/station_squad_art.js（SPR_SRC 註冊）
import collections, base64, io, os, json
import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage

BG = np.array([123, 122, 122], float)
OUT = '/home/claude/gb/art/cut_stn_ab/'; os.makedirs(OUT, exist_ok=True)

def unbg(a, lo=9, hi=44, gap=260):
    a = a.astype(float); h, w, _ = a.shape
    d = np.abs(a - BG).max(2)
    soft = d < hi
    # 由四邊 flood fill（只行色差細嘅格）→ 背景＋光暈
    lab, n = ndimage.label(soft)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    R = np.isin(lab, list(edge))
    # 圍住嘅灰底空隙（手臂內、霧圈中間）
    gl, gn = ndimage.label((d < lo + 3) & ~R)
    if gn:
        gs = ndimage.sum(np.ones_like(gl), gl, range(1, gn + 1))
        big = [i + 1 for i, v in enumerate(gs) if v >= gap]
        if big:
            hole = np.isin(gl, big); hole = ndimage.binary_dilation(hole, iterations=2) & soft & ~R
            R |= hole
    al = np.ones((h, w))
    k = np.clip((d - lo) / (hi - lo), 0, 1); k = k * k * (3 - 2 * k)
    al[R] = k[R]
    # 反混色：P = a*C + (1-a)*BG
    C = a.copy(); m = R & (al > 0.02)
    C[m] = np.clip((a[m] - (1 - al[m, None]) * BG) / al[m, None], 0, 255)
    rgba = np.dstack([C, al * 255]).astype(np.uint8)
    # 去走細碎噪點
    A = rgba[..., 3] > 20; lab2, n2 = ndimage.label(A)
    if n2 > 1:
        sz = ndimage.sum(np.ones_like(lab2), lab2, range(1, n2 + 1)); mx = sz.max()
        kill = [i + 1 for i, v in enumerate(sz) if v < max(60, mx * 0.002)]
        rgba[np.isin(lab2, kill)] = 0
    return Image.fromarray(rgba, 'RGBA')

def segs(mask_cols, n, total):
    # 每格分界：近 k*total/n 嘅最少前景嗰條直線
    cuts = [0]
    for k in range(1, n):
        c0 = int(total * k / n); lo, hi = c0 - 50, c0 + 50
        cuts.append(lo + int(np.argmin(mask_cols[lo:hi])))
    cuts.append(total); return cuts

SPLIT_FIX = []; HARD_CUT = []; BEAM_KILL = []; BEAM_FADE = []
def cut_sheet(path, nrows, ncols, rows_y, names, pad=6):
    # 整條橫行一齊去背，再按連通塊重心分返入每格（光束、咪高峰過界都唔會切爛）
    im = np.array(Image.open(path).convert('RGB')); H, W, _ = im.shape
    res = {}
    for r in range(nrows):
        y0, y1 = rows_y[r]
        a = np.full((y1 - y0 + 2 * pad, W + 2 * pad, 3), BG, np.uint8); a[pad:-pad, pad:-pad] = im[y0:y1]
        img = unbg(a); A = np.array(img); al = A[..., 3] > 6
        strong = A[..., 3] > 150
        for (rr, xc) in HARD_CUT:   # 實色塊相連（光束掂到隔籬）：喺呢條直線切開
            if rr == r: strong[:, xc + pad] = False
        lab, n = ndimage.label(strong, structure=np.ones((3, 3)))
        cw = (W + 2 * pad) / ncols; cellOf = np.full(n + 1, -1)
        for i in range(1, n + 1):
            ys, xs = np.nonzero(lab == i)
            if len(xs) < 30: continue
            cellOf[i] = min(ncols - 1, int(xs.mean() // cw))
            if xs.max() - xs.min() > cw * 1.25: print('WARN wide comp', r, xs.min(), xs.max())
        # 弱 alpha（光暈、光束、陰影）跟最近嘅實色塊
        lab2 = np.where(cellOf[lab] >= 0, lab, 0)
        _, (iy, ix) = ndimage.distance_transform_edt(lab2 == 0, return_indices=True)
        own = cellOf[lab2[iy, ix]]
        for (rr, x0, x1, c) in SPLIT_FIX:   # 手動修正：光束尾跟返電筒手
            if rr == r: m = (own == c + 1) & (np.arange(al.shape[1])[None, :] >= x0) & (np.arange(al.shape[1])[None, :] < x1) & ~strong; own[m] = c
        cells = [(own == c) & al for c in range(ncols)]
        for c in range(ncols):
            nm = names[r][c]
            if not nm: continue
            B = A.copy(); B[~cells[c]] = 0
            for (rr, cc, x1) in BEAM_KILL:   # 隔籬光束尾：淺黃色、喺 x1 左邊 → 拎走
                if rr == r and cc == c:
                    X = np.arange(B.shape[1])[None, :] - pad; lum = B[..., :3].astype(int).mean(2); warm = B[..., 0].astype(int) - B[..., 2]
                    B[(X < x1) & (lum > 95) & (warm > 18)] = 0
            for (rr, cc, xa, xb) in BEAM_FADE:   # 光束尾漸淡，唔好一刀切
                if rr == r and cc == c:
                    X = np.arange(B.shape[1]) - pad; k = np.clip((xb - X) / (xb - xa), 0, 1)[None, :]
                    B[..., 3] = (B[..., 3] * np.where(X[None, :] > xa, k, 1)).astype(np.uint8)
            im2 = Image.fromarray(B, 'RGBA')
            res[nm] = im2.crop(im2.getchannel('A').point(lambda v: 255 if v > 10 else 0).getbbox())
    return res

def feet_center(img):
    a = np.array(img.getchannel('A')) > 120; h = a.shape[0]
    band = a[int(h * 0.88):]; xs = np.where(band.any(0))[0]
    return (xs.min() + xs.max()) / 2 if len(xs) else img.width / 2

def center_on(img, cx):
    # 左右補透明，令腳底中心 = 圖中心（走路分腳同落地點先準）
    l, r = cx, img.width - cx; half = int(np.ceil(max(l, r)))
    out = Image.new('RGBA', (half * 2, img.height), (0, 0, 0, 0)); out.paste(img, (int(round(half - cx)), 0)); return out

def b64(img, q):
    bio = io.BytesIO(); img.save(bio, 'WEBP', quality=q, method=6); return 'data:image/webp;base64,' + base64.b64encode(bio.getvalue()).decode(), len(bio.getvalue())

# ---------- A：角色 ----------
CH = [['pb_sq_host', 'pb_sq_cam', 'pb_sq_aide', 'pb_sq_live'],
      ['pb_sq_lead', 'pb_sq_vcam', 'pb_sq_torch', 'pb_sq_sound'],
      ['pb_guide', 'pb_ghostclub', 'pb_walkdel', 'pb_hawker']]
SPLIT_FIX = [(1, 700, 782, 2)]; HARD_CUT = [(1, 782)]; BEAM_KILL = [(1, 3, 812)]; BEAM_FADE = [(1, 2, 735, 781)]
chars = cut_sheet('/home/claude/gen_art/gb_chibi_sheet2.png', 3, 4, [(100, 528), (568, 980), (1022, 1436)], CH)
# 腳底中心：有道具喺地（腳架、手推車）嘅用身體中心
FEET = {'pb_sq_live': None, 'pb_hawker': None}
out = {}
for k, img in chars.items():
    if k in ('pb_sq_live',):   # 腳架喺右邊：用人嘅腳（左邊 65%）
        a = np.array(img.getchannel('A')) > 120; h = a.shape[0]; band = a[int(h * 0.9):, :int(img.width * 0.62)]; xs = np.where(band.any(0))[0]; cx = (xs.min() + xs.max()) / 2
    elif k == 'pb_hawker':
        cx = img.width / 2
    else:
        cx = feet_center(img)
    img = center_on(img, cx)
    s = 300 / img.height; img = img.resize((max(1, round(img.width * s)), 300), Image.LANCZOS)
    img.save(OUT + k + '.png'); out[k] = img
    print(k, img.size)

# ---------- B：特效 ----------
VX = [['vfx_ghost_rise', 'vfx_ghost_lunge', 'vfx_ghost_smoke', 'vfx_hand_crack'],
      ['vfx_mist_ring', 'vfx_water_hands', 'vfx_frost', 'vfx_seal']]
SPLIT_FIX = []; HARD_CUT = []; BEAM_KILL = []; BEAM_FADE = []
fx = cut_sheet('/home/claude/gen_art/gb_vfx_sheet.png', 2, 4, [(40, 476), (546, 956)], VX)
for k, img in fx.items():
    s = 320 / max(img.size); img = img.resize((max(1, round(img.width * s)), max(1, round(img.height * s))), Image.LANCZOS)
    img.save(OUT + k + '.png'); out[k] = img
    print(k, img.size)

# ---------- 寫 JS ----------
tot = 0; lines = []
for k, img in out.items():
    u, n = b64(img, 86 if k.startswith('pb_') else 84); tot += n
    lines.append(f"  {k}:'{u}',")
js = ('// ===================== 陽間站崗 A／B 批美術（art/cut_stn_ab.py 由 gen_art/gb_chibi_sheet2.png、gb_vfx_sheet.png 自動切圖生成，唔好手改）=====================\n'
      '// pb_sq_*：網紅組／探險組專屬造型；pb_guide／pb_ghostclub／pb_walkdel／pb_hawker：新路人；vfx_*：設備特效。全部透明 webp，角色高 300px、腳底置中。\n'
      '// 喺 sprites.js 之後載入，所以自己 new Image 一次＋decode（同 SPR 共用），唔會重複載入。\n'
      'const STN_AB_SRC = {\n' + '\n'.join(lines) + '\n};\n'
      "const STN_AB_NOLEG = { pb_sq_live:1, pb_hawker:1 }; // 有道具喺地（腳架、手推車）：唔分腳，只係上下彈＋左右擺\n"
      "(() => { if (typeof SPR === 'undefined') return; if (typeof SPR_SRC !== 'undefined') Object.assign(SPR_SRC, STN_AB_SRC);\n"
      "  for (const k in STN_AB_SRC) { if (SPR[k]) continue; const im = new Image(); im.src = STN_AB_SRC[k]; SPR[k] = im; const ok = () => { im._ok = true; }; if (im.decode) im.decode().then(ok, () => { im.onload = ok; }); else im.onload = ok; } })();\n")
open('/home/claude/gb/src/station_squad_art.js', 'w').write(js)
print('total bytes', tot)
