#!/usr/bin/env python3
"""普通鬼拼裝測試（第一批部件）：身體＋衣服＋頭＋髮型＋配件，隨機 12 隻。"""
import random, sys
from PIL import Image
D = "parts1"
P = lambda i: Image.open(f"{D}/part_{i:02d}.png").convert("RGBA")
BODY = [0, 1]; FACE = [2, 3, 4, 5]; HAIR = [6, 7, 8, 9, None]; TOP = [10, 11, 12, 13, None]
ACC = {"lanyard": 14, "pouch": 15, "watch": 16, "mask": 17}
def scale(im, w): return im.resize((int(w), int(im.height * w / im.width)), Image.LANCZOS)
def ghost(rnd, seed_tint=True):
    b = P(rnd.choice(BODY)); bw, bh = b.size
    cv = Image.new("RGBA", (300, 420)); bx, by = (300 - bw) // 2, 420 - bh - 5
    neck = (bx + bw // 2, by + 8)
    cv.alpha_composite(b, (bx, by))
    t = rnd.choice(TOP)
    if t is not None:   # 衣服蓋住上身：寬度貼身體寬 0.95，頂部對齊頸
        o = scale(P(t), bw * 0.95); cv.alpha_composite(o, (neck[0] - o.width // 2, neck[1] + 4))
    acc = rnd.choice([None, "lanyard", "pouch", "watch", "mask", None])
    if acc == "lanyard":
        a = scale(P(ACC[acc]), bw * 0.30); cv.alpha_composite(a, (neck[0] - a.width // 2, neck[1] + 8))
    elif acc == "pouch":
        a = scale(P(ACC[acc]), bw * 0.28); cv.alpha_composite(a, (bx + int(bw * 0.62), by + int(bh * 0.42)))
    elif acc == "watch":
        a = scale(P(ACC[acc]), bw * 0.22); cv.alpha_composite(a, (bx + int(bw * 0.02), by + int(bh * 0.55)))
    f = scale(P(rnd.choice(FACE)), bw * 0.78); fx, fy = neck[0] - f.width // 2, neck[1] - f.height + 12
    cv.alpha_composite(f, (fx, fy))
    if acc == "mask":
        a = scale(P(ACC[acc]), f.width * 0.62); cv.alpha_composite(a, (neck[0] - a.width // 2, fy + int(f.height * 0.55)))
    h = rnd.choice(HAIR)
    if h is not None:
        hi = P(h); w = f.width * (1.05 if h != 9 else 0.72)
        hi = scale(hi, w)
        hy = fy - int(hi.height * (0.30 if h != 8 else 0.12)) if h != 9 else fy - int(hi.height * 0.55)
        cv.alpha_composite(hi, (neck[0] - hi.width // 2 + (int(f.width*0.08) if h == 8 else 0), hy))
    return cv
if __name__ == "__main__":
    rnd = random.Random(int(sys.argv[2]) if len(sys.argv) > 2 else 7)
    sh = Image.new("RGBA", (300 * 6, 420 * 2), (52, 46, 52, 255))
    for i in range(12): sh.alpha_composite(ghost(rnd), ((i % 6) * 300, (i // 6) * 420))
    sh.convert("RGB").save(sys.argv[1], quality=88)
