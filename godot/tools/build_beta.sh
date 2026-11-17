#!/bin/bash
# 測試版建置：bash godot/tools/build_beta.sh <版本名> <版本號> [--selftest] [--pck-only]
# - 由 git HEAD 匯出乾淨副本（/tmp/beta/godot），複製 .godot 匯入快取
# - 改 project.godot／export_presets.cfg 版本
# - 已啟用原生（native/ACTIVE.txt）嘅模塊唔再打包 jsgen/<模塊>.gd
#   例外：原生版平時仍要載轉譯版嘅（native/<m>.gd 有 load("res://jsgen/<m>.gd")），
#   除非列喺 native/JSGEN_DROP_OK.txt（只係對照測試／死路後備先用）
# - --selftest：匯出前用乾淨用戶資料夾跑全面自檢（34 項），唔過就停
# - 匯出 Android debug APK → /mnt/user-data/outputs/GhostBattles_v<版本名>.apk
set -e
VER="${1:?版本名，例如 0.9.0}"; CODE="${2:?版本號，例如 24}"; shift 2
SELFTEST=0; PCK=0
for a in "$@"; do case "$a" in --selftest) SELFTEST=1;; --pck-only) PCK=1;; esac; done
REPO=/home/claude/ghost-battles
GD=/opt/godot/Godot_v4.3-stable_linux.x86_64
CACHE=/home/claude/gbgd/godot/.godot
OUT=/tmp/beta
rm -rf "$OUT" && mkdir -p "$OUT/build"
(cd "$REPO" && git archive HEAD godot | tar -x -C "$OUT")
cp -r "$CACHE" "$OUT/godot/"
cd "$OUT/godot"

# 版本
sed -i "s/config\/version=\"[^\"]*\"/config\/version=\"$VER\"/" project.godot
sed -i "s/^version\/code=.*/version\/code=$CODE/; s/^version\/name=.*/version\/name=\"$VER\"/" export_presets.cfg

# 要剔走嘅 jsgen
DROP=()
[ -n "$NODROP" ] && echo "NODROP：唔剔 jsgen（對比用）"
for m in $(grep -v '^#' native/ACTIVE.txt | sed 's/[[:space:]]//g' | grep -v '^$'); do
	[ -n "$NODROP" ] && break
	[ -f "jsgen/$m.gd" ] || continue
	if grep -q "res://jsgen/$m.gd" "native/$m.gd" 2>/dev/null && ! grep -qx "$m" native/JSGEN_DROP_OK.txt 2>/dev/null; then
		echo "保留 jsgen/$m.gd（原生版仍會載入）"; continue
	fi
	DROP+=("jsgen/$m.gd")
done
EXC="tools/*"
for f in "${DROP[@]}"; do EXC="$EXC,$f"; done
python3 - "$EXC" <<'EOF'
import sys,re
exc=sys.argv[1]; p='export_presets.cfg'; s=open(p).read()
# 所有 preset 都用同一個 exclude（Android、Linux 等）
s=re.sub(r'exclude_filter="[^"]*"', 'exclude_filter="%s"' % exc, s)
open(p,'w').write(s)
EOF
echo "剔走 ${#DROP[@]} 個 jsgen 模塊"
printf '%s\n' "${DROP[@]}" > "$OUT/build/dropped.txt"

flock /tmp/godot.lock timeout 900 "$GD" --headless --path . --import >/dev/null 2>&1 || true

if [ $SELFTEST = 1 ]; then
	U="$OUT/xdg_st"; mkdir -p "$U"
	echo '[["wait",590],["quit"]]' > "$OUT/st.json"
	flock /tmp/godot.lock bash -c "XDG_DATA_HOME=$U GB_TEST=$OUT/st.json GB_SELFTEST=1 timeout 640 xvfb-run -a -s '-screen 0 450x975x24' $GD --path . --rendering-driver opengl3 > $OUT/build/selftest.log 2>&1" || true
	F=$(find "$U" -name selftest.json | head -1)
	python3 - "$F" <<'EOF'
import json,sys
d=json.load(open(sys.argv[1])); r=d.get('res',{})
bad={k:v for k,v in r.items() if v!='OK' and k!='info'}
print('自檢 %d 項' % len(r), '全過' if not bad and len(r)>=34 else bad)
sys.exit(0 if not bad and len(r)>=34 else 1)
EOF
fi

if [ $PCK = 1 ]; then
	flock /tmp/godot.lock timeout 900 "$GD" --headless --path . --export-pack Linux "$OUT/build/GhostBattles.pck" > "$OUT/build/export.log" 2>&1
	ls -la "$OUT/build/GhostBattles.pck"; exit 0
fi
flock /tmp/godot.lock timeout 900 "$GD" --headless --path . --export-debug Android "$OUT/build/GhostBattles.apk" > "$OUT/build/export.log" 2>&1
ls -la "$OUT/build/GhostBattles.apk"
mkdir -p /mnt/user-data/outputs
cp "$OUT/build/GhostBattles.apk" "/mnt/user-data/outputs/GhostBattles_v$VER.apk"
echo "完成：/mnt/user-data/outputs/GhostBattles_v$VER.apk"
