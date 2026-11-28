#!/usr/bin/env python3
# 上線前檢查（rv_clear_test 會叫）：
#   python3 rv_build_check.py <godot目錄> [build.py 路徑]
# 1. 列出 data/story_v2.json 仍帶 rv（待審）的插圖。
# 2. 把 data/ 複製到暫存目錄，重跑 build.py --force，確認：已拿掉的 rv 沒有被加回來、仍待審的 rv 沒有被抹走、插圖鍵沒有變、第一章開場沒有被塞回 stall_hook。
import json, sys, os, shutil, subprocess, tempfile
R = sys.argv[1]; B = sys.argv[2] if len(sys.argv) > 2 else "/home/claude/meeting/vil2/opening/build.py"
def specs(root):
    d = json.load(open(root + "/data/story_v2.json")); o = {}
    for sid, sc in d["scenes"].items():
        cg = sc.get("cg")
        if isinstance(cg, dict):
            for li, v in cg.items():
                if isinstance(v, dict): o["%s:%s" % (sid, li)] = (v.get("k", ""), v.get("kf", ""), v.get("rv", ""))
    return o
a = specs(R)
rv = sorted(k for k, v in a.items() if v[2])
print("RV_COUNT %d" % len(rv))
for k in rv: print("RV %s k=%s kf=%s" % (k, a[k][0], a[k][1]))
if not os.path.exists(B): print("BUILD skip（找不到 build.py：%s）" % B); sys.exit(0)
T = tempfile.mkdtemp(prefix="rvchk_")
try:
    shutil.copytree(R + "/data", T + "/data")
    r0 = subprocess.run([sys.executable, B, T], capture_output=True, text=True)
    same0 = specs(T) == a and open(T + "/data/story_v2.json").read() == open(R + "/data/story_v2.json").read()
    print("BUILD_NOFORCE %s" % ("ok" if same0 else "CHANGED"))
    r = subprocess.run([sys.executable, B, T, "--force"], capture_output=True, text=True)
    if r.returncode != 0: print("BUILD_FORCE ERROR " + r.stderr.strip().splitlines()[-1][:200]); sys.exit(0)
    b = specs(T)
    back = sorted(k for k in b if b[k][2] and not a.get(k, ("", "", ""))[2])
    lost = sorted(k for k in a if a[k][2] and not b.get(k, ("", "", ""))[2])
    keys = sorted(k for k in a if a[k][:2] != b.get(k, ("?", "?", ""))[:2])
    ch1 = json.load(open(T + "/data/nat/data.json"))["CHAPTERS"][0]["intro"]
    print("BUILD_FORCE back=%d lost=%d keychg=%d stall_in_intro=%d" % (len(back), len(lost), len(keys), int("stall_hook" in ch1)))
    for k in back + lost + keys: print("  DIFF " + k)
finally:
    shutil.rmtree(T, ignore_errors=True)
