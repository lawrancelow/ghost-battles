# -*- coding: utf-8 -*-
"""[mapx] 野外分圈地面：瓦片（tiles）模式烘圖。
用法：python3 tools/mapx_ground.py            （讀 data/nat/zones.json 嘅 ext／rings／sorties，寫 assets/img/mapx_ground_<ci>.webp）
做法：
  1. 每圈一套地表瓦片（可平鋪）：近郊 grass／dirt、荒野 drygrass／earth、深處 swamp／stone、最外圈 rock／gravel
     ★ 換圖接口（集中呢度）：TILE_DIR 有 tile_<圈>_<類>.webp 就用，冇就用 _proc_tile 程序暫代（地面色調＋週期噪聲，無縫）
  2. 程序生成（固定 seed）：低頻噪聲決定每圈兩種地表點分佈（例如近郊草地入面一塊塊泥地、深處沼澤水塘、最外圈岩塊）；
     圈與圈之間用「帶噪聲嘅距離」做柔和過渡（約 140px），冇方塊感；沿據點路線（出咗核心地圖嗰段）畫泥路
  3. 烘成一張大圖（世界 ext 範圍，SCALE＝0.5：每個像素＝2 世界 px），核心地圖範圍透明（原有地面唔郁）
     遊戲（zone_rings.gd）只畫鏡頭入面嗰塊（draw_texture_rect_region），唔會逐格畫
"""
import json, os, sys, math
import numpy as np
from PIL import Image, ImageFilter
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZJ = os.path.join(ROOT, "data", "nat", "zones.json")
OUTD = os.path.join(ROOT, "assets", "img")
TILE_DIR = "/home/claude/docs/art/tiles"
SCALE = 0.5
TS = 128          # 瓦片喺烘圖入面嘅邊長（原圖 256 → 每格＝256 世界 px，縮細一半配 SCALE）
BLEND = 160.0     # 圈與圈過渡闊（世界 px）
# ★ 換圖接口（集中呢度）：每圈 [(瓦片名, 噪聲門檻, 噪聲格大細)]；第一個係主地表（全鋪），後面嘅喺噪聲 > 門檻嘅地方混入（邊緣柔和）
#   瓦片名 → TILE_DIR/tile_<名>.webp；冇檔就用 PROC 程序暫代
RING_TILES = {1: [("near_grass", 0, 0), ("near_dirt", 0.66, 110)],
              2: [("wild_drygrass", 0, 0), ("wild_gravesoil", 0.55, 120)],
              3: [("deep_swampmud", 0, 0), ("deep_stonepave", 0.58, 140), ("deep_water", 0.64, 90)],
              4: [("mt_rock", 0, 0), ("wild_gravesoil", 0.72, 100)]}
PATH_TILE = "near_dirt"
PROC = {"near_grass": ("#2e3a24", "#3f4e2e", "#1f281a", 6), "near_dirt": ("#4a3a2a", "#5c4a36", "#33281e", 4),
        "wild_drygrass": ("#4a4430", "#5e5638", "#2e2a20", 5), "wild_gravesoil": ("#3a2e26", "#4a3a30", "#261e1a", 3),
        "deep_stonepave": ("#3a3e3a", "#50544e", "#262a28", 3), "deep_swampmud": ("#1e2e2a", "#2e4440", "#121c1a", 8),
        "deep_water": ("#16262a", "#2a4048", "#0c1416", 9), "mt_rock": ("#3e3e46", "#56565e", "#28282e", 4)}
def _hex(h): return np.array([int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16)], dtype=np.float32)
def _pnoise(n, sigma, rnd):
    """週期（無縫）噪聲：白噪聲喺頻域做高斯低通"""
    w = rnd.standard_normal((n, n))
    f = np.fft.fft2(w); ky = np.fft.fftfreq(n)[:, None]; kx = np.fft.fftfreq(n)[None, :]
    g = np.exp(-(kx ** 2 + ky ** 2) * (2 * math.pi * sigma) ** 2 / 2)
    o = np.real(np.fft.ifft2(f * g)); o = (o - o.mean()) / (o.std() + 1e-6)
    return o
def _proc_tile(kind, seed):
    base, lit, dark, grain = PROC[kind]; rnd = np.random.default_rng(seed)
    a = _pnoise(TS, grain * 2.2, rnd) * 0.6 + _pnoise(TS, grain * 0.6, rnd) * 0.4
    B, L, D = _hex(base), _hex(lit), _hex(dark)
    t = np.clip(a * 0.5, -1, 1)[..., None]
    img = np.where(t > 0, B + (L - B) * t, B + (B - D) * t)
    if kind in ("grass", "drygrass"):   # 草葉：細碎亮點
        sp = rnd.random((TS, TS)) > 0.985; img[sp] = img[sp] * 0.6 + L * 0.6
    if kind == "swamp":   # 水面反光
        s = _pnoise(TS, 3, rnd); img[s > 1.6] = img[s > 1.6] * 0.7 + np.array([90, 110, 100]) * 0.3
    if kind in ("rock", "gravel", "stone"):   # 石縫
        s = np.abs(_pnoise(TS, 5 if kind != "gravel" else 1.5, rnd)); img[s < 0.08] *= 0.55
    return np.clip(img, 0, 255).astype(np.uint8)
_TC = {}
def tile(kind):
    if kind in _TC: return _TC[kind]
    p = os.path.join(TILE_DIR, "tile_%s.webp" % kind)
    if os.path.exists(p):
        im = Image.open(p).convert("RGB").resize((TS, TS), Image.LANCZOS); r = (np.asarray(im).copy(), "art")
    else: r = (_proc_tile(kind, sum(map(ord, kind))), "proc")
    _TC[kind] = r; return r
def _layer(t, yy, xx, ox, oy, rot, flip, sc):
    """瓦片平鋪一層：整層旋轉 90° 倍數／翻轉（成層一齊轉，接縫照舊無縫）＋偏移＋縮放 → 兩三層用噪聲混合打散重複"""
    tt = np.rot90(t, rot)
    if flip: tt = tt[:, ::-1]
    n = tt.shape[0]
    iy = ((yy * sc + oy).astype(np.int64)) % n; ix = ((xx * sc + ox).astype(np.int64)) % n
    return tt[iy, ix].astype(np.float32)
def _mix(kind, yy, xx, rnd, H, W):
    t, src = tile(kind)
    A = _layer(t, yy, xx, 0, 0, 0, False, 1.0)
    B = _layer(t, yy, xx, 53, 97, 1, True, 0.83)
    C = _layer(t, yy, xx, 211, 31, 2, False, 1.21)
    n1 = _vnoise(H, W, 70, rnd); n2 = _vnoise(H, W, 110, rnd)
    wa = np.clip(1.2 - n1 * 1.6, 0, 1); wb = np.clip(n1 * 1.6 - 0.4, 0, 1) * (1 - np.clip(n2 * 2 - 1, 0, 1)); wc = np.clip(n2 * 2 - 1, 0, 1)
    ws = wa + wb + wc + 1e-4
    return (A * wa[..., None] + B * wb[..., None] + C * wc[..., None]) / ws[..., None], src
def _vnoise(h, w, cell, rnd):
    """平滑值噪聲（雙三次放大），用嚟決定地表分佈"""
    gh, gw = h // cell + 3, w // cell + 3
    g = Image.fromarray((rnd.random((gh, gw)) * 255).astype(np.uint8))
    g = g.resize((gw * cell, gh * cell), Image.BICUBIC)
    return np.asarray(g, dtype=np.float32)[:h, :w] / 255.0

def bake(ci, M):
    x0, y0, x1, y1 = M["ext"]; W = int((x1 - x0) * SCALE); H = int((y1 - y0) * SCALE)
    rnd = np.random.default_rng(4200 + ci)
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    wx = xx / SCALE + x0; wy = yy / SCALE + y0
    cw, ch = M["w"], M["h"]
    # 到核心地圖嘅「方形距離」（Chebyshev）＋噪聲擾動 → 決定屬邊圈
    dx = np.maximum(np.maximum(-wx, wx - cw), 0); dy = np.maximum(np.maximum(-wy, wy - ch), 0)
    d = np.maximum(dx, dy)
    jit = (_vnoise(H, W, 60, rnd) - 0.5) * 2 * 90 + (_vnoise(H, W, 14, rnd) - 0.5) * 2 * 24
    dj = d + jit
    edges = []; acc = 0
    for rg in M["rings"]:
        acc += rg["inner"][0] - rg["outer"][0]; edges.append(acc)
    out = np.zeros((H, W, 3), dtype=np.float32)
    wsum = np.zeros((H, W), dtype=np.float32)
    src = {}
    det = _vnoise(H, W, 90, rnd)   # 副地表分佈
    det2 = _vnoise(H, W, 30, rnd)
    for i, rg in enumerate(M["rings"]):
        k = rg["ring"]; lo = edges[i - 1] if i else -1e9; hi = edges[i] if i < len(edges) - 1 else 1e9
        # 圈權重：喺 [lo, hi] 入面＝1，邊界兩邊 BLEND/2 內線性淡出（splat 柔和過渡，邊界帶噪聲擾動 → 唔係直線）
        wgt = np.clip((dj - (lo - BLEND / 2)) / BLEND, 0, 1) * np.clip(((hi + BLEND / 2) - dj) / BLEND, 0, 1)
        if not wgt.any(): continue
        lay = RING_TILES[k]
        T, s0 = _mix(lay[0][0], yy, xx, rnd, H, W); used = [(lay[0][0], s0)]
        for kind, thr, cell in lay[1:]:
            Bt, sb = _mix(kind, yy + 37, xx + 71, rnd, H, W); used.append((kind, sb))
            mv = _vnoise(H, W, int(cell * SCALE * 2), rnd) * 0.75 + _vnoise(H, W, int(cell * SCALE * 0.6) + 2, rnd) * 0.25
            mb = np.clip((mv - thr) / 0.07, 0, 1)[..., None]
            T = T * (1 - mb) + Bt * mb
        src[k] = used
        # 每圈大尺度色調噪聲（同圈唔平板）
        tint = 1.0 + (_vnoise(H, W, 160, rnd) - 0.5) * 0.18
        out += T * (tint * wgt)[..., None]; wsum += wgt
    out /= np.maximum(wsum, 1e-4)[..., None]
    # 泥路：沿每個據點路線（核心地圖外嗰段）畫闊約 34 世界 px 嘅泥路，邊緣柔
    path = Image.new("L", (W, H), 0)
    from PIL import ImageDraw
    dr = ImageDraw.Draw(path)
    for s in M["sorties"]:
        pts = [((p[0] - x0) * SCALE, (p[1] - y0) * SCALE) for p in s["route"][-3:]]
        dr.line(pts, fill=255, width=int(34 * SCALE));
        for q in pts[1:]: dr.ellipse([q[0] - 17 * SCALE, q[1] - 17 * SCALE, q[0] + 17 * SCALE, q[1] + 17 * SCALE], fill=255)
        q = pts[-1]; r = 70 * SCALE; dr.ellipse([q[0] - r, q[1] - r * 0.55, q[0] + r, q[1] + r * 0.55], fill=255)   # 據點空地
    path = np.asarray(path.filter(ImageFilter.GaussianBlur(4)), dtype=np.float32)[..., None] / 255.0
    D, _ = _mix(PATH_TILE, yy + 13, xx + 29, rnd, H, W); D *= 0.9
    out = out * (1 - path * 0.85) + D * path * 0.85
    # 整體明暗：大塊低頻光影（唔平板）
    sh = (_vnoise(H, W, 220, rnd) - 0.5) * 0.30 + 0.92
    out = np.clip(out * sh[..., None], 0, 255)
    alpha = np.where((wx >= 0) & (wx < cw) & (wy >= 0) & (wy < ch), 0, 255).astype(np.uint8)
    img = Image.fromarray(np.dstack([out.astype(np.uint8), alpha]), "RGBA")
    p = os.path.join(OUTD, "mapx_ground_%d.webp" % ci)
    img.save(p, "WEBP", quality=82, method=4)
    return p, (W, H), src

if __name__ == "__main__":
    D = json.load(open(ZJ, encoding="utf-8"))
    for c, M in D["maps"].items():
        if "ext" not in M: continue
        p, sz, src = bake(int(c), M)
        print("wrote", p, sz, src)
