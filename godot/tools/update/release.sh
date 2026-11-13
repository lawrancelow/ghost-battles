#!/bin/bash
# 熱更新發佈工具
#   bash tools/update/release.sh base            # 出新安裝包嗰陣：記錄各平台「基礎清單」（之後補丁同佢比較）
#   bash tools/update/release.sh patch <repo>    # 出補丁：同基礎清單比較 → 每平台一個 pck → 寫入 <repo>/godot-update/ 同 version.json
set -e
cd "$(dirname "$0")/../.."
G=${GODOT:-/opt/godot/Godot_v4.3-stable_linux.x86_64}
VER=$(grep -oP 'config/version="\K[^"]+' project.godot)
PLATS="Android:android iOS:ios Windows:windows macOS:macos Linux:linux"
TMP=/tmp/gb_update; mkdir -p $TMP tools/update/base/$VER
if [ "$1" = patch ]; then
  N=$(python3 -c "import json,os,sys;p='$2/godot-update/version.json';o=json.load(open(p)) if os.path.exists(p) else {};print(max([0]+[int(v.get('ver',0)) for v in o.get('base',{}).get('$VER',{}).values()])+1)")
  echo "補丁版本 $N"
fi
$G --headless --path . --import >/dev/null 2>&1 || true
for pp in $PLATS; do
  P=${pp%%:*}; K=${pp##*:}
  rm -f $TMP/$K.pck
  timeout 900 $G --headless --path . --export-pack "$P" $TMP/$K.pck >/dev/null 2>&1 || true
  [ -f $TMP/$K.pck ] || { echo "export $P failed"; exit 1; }
  if [ "$1" = base ]; then
    python3 tools/update/pck.py manifest $TMP/$K.pck tools/update/base/$VER/$K.json
  else
    REPO=$2; OUT=$REPO/godot-update; mkdir -p $OUT
    rm -rf $TMP/diff_$K
    python3 tools/update/pck.py diff $TMP/$K.pck tools/update/base/$VER/$K.json $TMP/diff_$K
    python3 - "$OUT/version.json" "$VER" "$K" "$TMP/diff_$K" "$G" "$OUT" "$N" <<'PY'
import json, sys, os, hashlib, subprocess
vj, ver, k, d, g, out, n = sys.argv[1:]; n = int(n)
o = json.load(open(vj)) if os.path.exists(vj) else {"base": {}}
cur = o["base"].setdefault(ver, {}).get(k, {})
fn = f"p_{ver.replace('.','')}_{k}_{n}.pck"
lst = os.path.join(d, "_list.json")
if len(json.load(open(lst))) == 0:
    print(k, "冇改動，唔出補丁"); sys.exit(0)
subprocess.run([g, "--headless", "-s", os.path.abspath("tools/update/make_pck.gd"), "--", lst, os.path.join(out, fn)], capture_output=True)
assert os.path.exists(os.path.join(out, fn)), "make_pck failed"
data = open(os.path.join(out, fn), "rb").read()
if cur.get("file") and os.path.exists(os.path.join(out, cur["file"])): os.remove(os.path.join(out, cur["file"]))
o["base"][ver][k] = {"ver": n, "file": fn, "md5": hashlib.md5(data).hexdigest(), "size": len(data)}
json.dump(o, open(vj, "w"), indent=1, ensure_ascii=False)
print(k, "patch", n, len(data), "bytes")
PY
  fi
done
