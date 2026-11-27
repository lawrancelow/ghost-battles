# 去白底：由四邊 flood fill 近白區域 → 透明；邊緣按白度做柔和 alpha
import sys, numpy as np
from PIL import Image
from scipy import ndimage
src, out = sys.argv[1], sys.argv[2]
im = np.array(Image.open(src).convert('RGB')).astype(np.float32)
mn = im.min(axis=2)                       # 白度：最暗通道
sat = im.max(axis=2) - mn
white = (mn > 215) & (sat < 28)
lab, n = ndimage.label(white)
edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
sizes = ndimage.sum(white, lab, range(n+1))
big = set(np.where(sizes > 600)[0]) - {0}
bg = np.isin(lab, list(edge | big))
# 把外部白區域膨脹 2px 內嘅淡色像素都計入半透明
near = ndimage.binary_dilation(bg, iterations=3) & ~bg
a = np.ones(mn.shape, np.float32)
a[bg] = 0
soft = np.clip((235 - mn) / 60.0, 0, 1)
soft = np.maximum(soft, np.clip(sat / 60.0, 0, 1))
a[near] = np.minimum(a[near], soft[near])
rgba = np.dstack([im, a * 255]).astype(np.uint8)
img = Image.fromarray(rgba, 'RGBA')
bb = img.getchannel('A').point(lambda v: 255 if v > 8 else 0).getbbox()
img = img.crop((max(bb[0]-6,0), max(bb[1]-6,0), min(bb[2]+6,img.width), min(bb[3]+6,img.height)))
img.save(out)
print(out, img.size)
