#!/usr/bin/env python3
"""重新整字型子集：舊子集 ∪ 遊戲用到嘅字（data/**/*.json、**/*.gd、**/*.tscn）∪（sans_r/sans_b 加 Big5 常用字一級）。
用法：python3 tools/font_subset.py        （喺 godot/ 目錄跑）
源字型：系統 Noto CJK TC（/usr/share/fonts/opentype/noto）。"""
import glob, os, sys
from fontTools.ttLib import TTFont, TTCollection
from fontTools import subset

SRC = {
    "sans_r": ("/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc", 3),
    "sans_b": ("/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc", 3),
    "sans_k": ("/usr/share/fonts/opentype/noto/NotoSansCJK-Black.ttc", 3),
    "serif_b": ("/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc", 3),
    "serif_k": ("/usr/share/fonts/opentype/noto/NotoSerifCJK-Black.ttc", 3),
}
used = set()
for pat in ["data/**/*.json", "**/*.gd", "**/*.tscn"]:
    for p in glob.glob(pat, recursive=True):
        if "/.godot/" in p: continue
        try: used |= set(open(p, encoding="utf-8").read())
        except Exception: pass
big5 = set()
for hi in range(0xA4, 0xC7):
    for lo in list(range(0x40, 0x7F)) + list(range(0xA1, 0xFF)):
        if hi == 0xC6 and lo > 0x7E: break
        try: big5.add(bytes([hi, lo]).decode("big5"))
        except Exception: pass
for name, (src, idx) in SRC.items():
    out = "fonts/%s.otf" % name
    old = set(chr(c) for c in TTFont(out).getBestCmap())
    want = old | used | (big5 if name in ("sans_r", "sans_b") else set())
    want = {c for c in want if ord(c) >= 0x20}
    col = TTCollection(src); f = col.fonts[idx]
    have = f.getBestCmap()
    keep = [ord(c) for c in want if ord(c) in have]
    opt = subset.Options(); opt.layout_features = ["*"]; opt.name_IDs = ["*"]; opt.notdef_outline = True
    opt.hinting = False; opt.desubroutinize = False
    s = subset.Subsetter(opt); s.populate(unicodes=keep); s.subset(f)
    f.save(out)
    miss = sorted(c for c in (used - set(chr(k) for k in keep)) if ord(c) > 0x2E80)
    print(name, "old", len(old), "new", len(keep), "size", os.path.getsize(out), "missing-used", "".join(miss[:40]))
