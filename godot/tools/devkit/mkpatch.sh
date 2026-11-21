# mkpatch.sh <basedir> <basever> <n>
set -e
B=$1; V=$2; N=$3; G=/opt/godot/Godot_v4.3-stable_linux.x86_64; OUT=/home/claude/wt/main/godot-update; PK=/home/claude/ghost-battles/godot/tools/update/pck.py
cd /tmp/new11/godot
for K in android linux; do P=$([ $K = android ] && echo Android || echo Linux)
 python3 $PK manifest $B/$P.pck $B/$K.json >/dev/null
 rm -rf /tmp/diff_${V}_$K; python3 $PK diff /tmp/new11/$P.pck $B/$K.json /tmp/diff_${V}_$K >/dev/null
 python3 - "$OUT/version.json" "$V" "$K" "/tmp/diff_${V}_$K" "$G" "$OUT" "$N" <<'PY'
import json, sys, os, hashlib, subprocess
vj, ver, k, d, g, out, n = sys.argv[1:]; n = int(n)
o = json.load(open(vj))
cur = o["base"].get(ver, {}).get(k, {})
fn = f"p_{ver.replace('.','')}_{k}_{n}.pck"
lst = os.path.join(d, "_list.json")
r=subprocess.run([g, "--headless", "-s", "/home/claude/ghost-battles/godot/tools/update/make_pck.gd", "--", lst, os.path.join(out, fn)], capture_output=True, text=True)
assert os.path.exists(os.path.join(out, fn)), r.stderr[-400:]
data = open(os.path.join(out, fn), "rb").read()
if cur.get("file") and cur["file"]!=fn and os.path.exists(os.path.join(out, cur["file"])): os.remove(os.path.join(out, cur["file"]))
o["base"].setdefault(ver, {})[k] = {"ver": n, "file": fn, "md5": hashlib.md5(data).hexdigest(), "size": len(data)}
json.dump(o, open(vj, "w"), indent=1, ensure_ascii=False)
print(ver, k, "patch", n, len(data), "bytes", len(json.load(open(lst))), "files")
PY
done
