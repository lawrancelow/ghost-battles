#!/usr/bin/env python3
# 考核官頭像出圈檢查。六張全過先算完成（任何一項唔過 exit 1）。
# 用法：python3 kpi_avatar_check.py <repo 根目錄>
# 檢查：
#  1 貼邊：大圖／細圖 alpha>0 嘅像素唔可以掂到畫布四邊（留最少 EDGE px）
#  2 頭部完整：成品喺頸線以上嘅不透明範圍，要同原圖頭部（縮放後）bbox 一致（±TOL），即冇被遮罩／畫布裁走
#  3 展腳：有官帽嘅四位，左右展腳尖都要喺畫布內，而且原圖展腳尖係收口（唔係被原圖邊界切平）
#  4 冇切口：頸線以下、圈外唔可以有實心角色像素（頸線兩端一定喺圈內）
#  5 大細圖一致：細圖＝大圖縮一半
import sys, json, numpy as np
from PIL import Image
ROOT = sys.argv[1] if len(sys.argv) > 1 else "."
SPR = f"{ROOT}/godot/assets/spr"; META = json.load(open(f"{ROOT}/art/vil2/kpi_boss/popout_meta.json"))
R = META["R"]; CAN = META["CAN"]; C = CAN // 2; EDGE = 8; TOL = 4
HAT = {"chen", "he", "qian", "dato"}
bad = 0
def chk(key, name, ok, info=""):
    global bad
    if not ok: bad += 1
    print(f"  [{'過' if ok else '敗'}] {key} {name} {info}")
def bbox(mask):
    ys, xs = np.nonzero(mask); return int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())
for key, m in META["bosses"].items():
    big = np.array(Image.open(f"{SPR}/kpi_boss_{key}.webp").convert("RGBA"))[:, :, 3]
    sm = np.array(Image.open(f"{SPR}/kpi_boss_{key}_s.webp").convert("RGBA"))[:, :, 3]
    chk(key, "畫布尺寸", big.shape == (CAN, CAN) and sm.shape == (CAN // 2, CAN // 2), f"{big.shape} {sm.shape}")
    for nm, a, e in (("大圖", big, EDGE), ("細圖", sm, EDGE // 2)):
        x0, y0, x1, y1 = bbox(a > 0)
        chk(key, f"{nm}唔貼邊", x0 >= e and y0 >= e and x1 < a.shape[1] - e and y1 < a.shape[0] - e, f"bbox={x0},{y0},{x1},{y1}")
    # 頭部完整：頸線以上、實心（>200，避開投影）範圍 vs 原圖頭部縮放 bbox
    ny = m["neck_y"]; hx0, hy0, hx1, hy1 = m["head_src_canvas"]
    yy, xx = np.mgrid[0:CAN, 0:CAN]; outc = (xx - C) ** 2 + (yy - C) ** 2 > (R + 6) ** 2
    solid = big > 200
    ox0, oy0, ox1, oy1 = bbox(solid & outc & (yy < ny))
    full = hx0 >= EDGE and hy0 >= EDGE and hx1 < CAN - EDGE
    chk(key, "頭部範圍喺畫布內", full, f"原圖頭部→畫布 x {hx0}..{hx1} y {hy0}..")
    chk(key, "頭頂完整", abs(oy0 - hy0) <= TOL, f"成品頂 {oy0} 原圖頂 {hy0}")
    # 出圈部分左右極值：原圖頭部如果闊過圈，成品要到齊
    if hx0 < C - R - 6: chk(key, "左邊出圈完整", abs(ox0 - hx0) <= TOL, f"成品 {ox0} 原圖 {hx0}")
    if hx1 > C + R + 6: chk(key, "右邊出圈完整", abs(ox1 - hx1) <= TOL, f"成品 {ox1} 原圖 {hx1}")
    chk(key, "頭頂出圈", oy0 < C - R - 10, f"出圈 {C - R - oy0}px")
    # 冇切口：頸線以下圈外冇實心像素；頸線兩端喺圈內
    cut = int(np.sum(solid & outc & (yy > ny + 8)))
    chk(key, "頸線以下圈外冇角色像素", cut == 0, f"{cut}px")
    half = (R * R - (ny - C) ** 2) ** 0.5
    chk(key, "頸線兩端喺圈內", m["neck_x"][0] > C - half and m["neck_x"][1] < C + half, f"{m['neck_x']} 圈 {int(C - half)}..{int(C + half)}")
    # 大細圖一致
    ds = np.array(Image.fromarray(big).resize((CAN // 2, CAN // 2), Image.LANCZOS)).astype(int)
    chk(key, "大細圖一致", float(np.mean(np.abs(ds - sm.astype(int)))) < 4.0)
    if key in HAT:
        # 展腳：原圖頭部區（頸線以上）最左／最右一列嘅實心段長，要明顯短過入面 14px 嗰列（即尖端收口，唔係被邊界切平）
        # 同 popout.py 一樣先刪漂浮道具、只留最大連通塊，先至量展腳
        from scipy import ndimage
        sa = np.array(Image.open(f"{SPR}/{m['src']}").convert("RGBA"))[:, :, 3].copy(); H0, W0 = sa.shape
        if m.get("prop"):
            p = m["prop"]; sa[int(p[1] * H0):int(p[3] * H0), int(p[0] * W0):int(p[2] * W0)] = 0
        lab, n = ndimage.label(sa > 24); sz = ndimage.sum(np.ones_like(lab), lab, range(1, n + 1))
        src = (lab == int(np.argmax(sz)) + 1) & (sa > 60)
        s = m["scale"]; nys = int(round((ny - m["oy"]) / s)); head = src[:nys]
        cols = np.nonzero(head.any(axis=0))[0]
        for side, c0, step in (("左", int(cols.min()), 1), ("右", int(cols.max()), -1)):
            tip = int(head[:, c0].sum()); inner = max(int(head[:, c0 + step * k].sum()) for k in range(10, 18))
            chk(key, f"{side}展腳尖收口（原圖冇被切）", tip <= 0.7 * inner, f"尖 {tip}px／身 {inner}px")
            cx = m["ox"] + c0 * s
            chk(key, f"{side}展腳尖喺畫布內", EDGE <= cx < CAN - EDGE, f"x={int(cx)}")
print("RESULT", "全部通過" if bad == 0 else f"唔過 {bad} 項")
sys.exit(1 if bad else 0)
