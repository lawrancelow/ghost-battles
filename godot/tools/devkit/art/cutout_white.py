# 白底 → 透明（王牌晉級立繪、主角空手姿勢）
#   rembg（isnet-general-use，Apache-2.0，可商用）出主體遮罩 → 收細少少做「實心區」；
#   實心區以外用「白色→透明」（color-to-alpha）：煙霧／鬼尾柔邊保留半透明，白底同白邊完全去走，顏色去白污染。
#   白色衫（白無常、聶小倩）喺實心區入面，唔會穿窿。最後裁到內容＋留邊，縮到最長邊 maxside。
# python3 cutout_white.py in.png out.webp [maxside=900]
import sys
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
from rembg import new_session, remove

_S = None
def sess():
    global _S
    if _S is None: _S = new_session("isnet-general-use")
    return _S

def cutout(src, maxside=900, pad=8):
    im = Image.open(src).convert("RGB")
    rgb = np.asarray(im).astype(np.float32)
    m = np.asarray(remove(im, session=sess(), only_mask=True)).astype(np.float32) / 255.0
    core = ndi.binary_erosion(m > 0.5, iterations=3)
    core = ndi.binary_fill_holes(core) & (m > 0.15) | core
    # color-to-alpha（對白）
    a2 = np.clip((255.0 - rgb.min(axis=2)) / 255.0, 0, 1)
    a2 = np.clip((a2 - 0.035) / 0.965, 0, 1)            # 紙底微灰當白
    # 只喺主體附近保留（遠處噪點／白底陰影去走）：遮罩擴闊 40px 以外清零
    near = ndi.binary_dilation(m > 0.08, iterations=40)
    a2[~near] = 0
    a = np.where(core, 1.0, a2)
    # 實心區邊緣羽化 1px（避免鋸齒）
    soft = ndi.gaussian_filter(core.astype(np.float32), 0.8)
    a = np.maximum(a, np.where(soft > 0.5, soft, 0) * (a2 > 0.02))
    a = np.clip(a, 0, 1)
    # 實心區貼住透明位嘅一圈（3px）：都用 color-to-alpha（去走內窿邊、頭髮縫嘅白線；深色描線 a2≈1 唔受影響）
    for _ in range(2):
        band = ndi.binary_dilation(a < 0.05, iterations=3) & core
        a = np.where(band, a2, a); core = core & ~band
    # 去白污染：非實心像素用 c2a 還原色
    aa = np.maximum(a, 1e-3)[..., None]
    dec = np.clip((rgb - 255.0 * (1 - aa)) / aa, 0, 255)
    col = np.where(core[..., None], rgb, dec)
    a[a < 0.03] = 0
    out = Image.fromarray(np.dstack([col, a * 255]).astype(np.uint8), "RGBA")
    bb = out.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    out = out.crop((max(0, bb[0] - pad), max(0, bb[1] - pad), min(out.width, bb[2] + pad), min(out.height, bb[3] + pad)))
    if max(out.size) > maxside:
        s = maxside / max(out.size); out = out.resize((round(out.width * s), round(out.height * s)), Image.LANCZOS)
    return out

if __name__ == "__main__":
    o = cutout(sys.argv[1], int(sys.argv[3]) if len(sys.argv) > 3 else 900)
    if sys.argv[2].endswith(".webp"): o.save(sys.argv[2], "WEBP", quality=90, method=6, exact=True)
    else: o.save(sys.argv[2])
    print(sys.argv[2], o.size)
