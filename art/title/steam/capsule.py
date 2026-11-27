# 用 B 款 Logo 重出 Steam 主膠囊：左側放 Logo，背後加柔和暗角保可讀
import sys
from PIL import Image, ImageFilter, ImageDraw
src, logo_p, out, W, H = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5])
bg = Image.open(src).convert('RGB').resize((W, H), Image.LANCZOS).convert('RGBA')
logo = Image.open(logo_p).convert('RGBA')
lw = int(W * 0.5); lh = int(lw * logo.height / logo.width)
logo = logo.resize((lw, lh), Image.LANCZOS)
x = int(W * 0.025); y = (H - lh) // 2 - int(H * 0.02)
# 暗角
m = Image.new('L', (W, H), 0); d = ImageDraw.Draw(m)
d.ellipse((x - lw * 0.05, y - lh * 0.05, x + lw * 1.05, y + lh * 1.05), fill=150)
m = m.filter(ImageFilter.GaussianBlur(W * 0.05))
dark = Image.new('RGBA', (W, H), (8, 5, 10, 255)); dark.putalpha(m)
bg.alpha_composite(dark)
bg.alpha_composite(logo, (x, y))
bg.convert('RGB').save(out)
print(out, bg.size)
