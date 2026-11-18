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
OUT="${BETA_OUT:-/tmp/beta}"   # 多條線同時打包要各自指定，唔係會互相刪資料夾
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

# 包內容檢查：ACTIVE.txt 一定要入包，否則手機上全部原生模塊都唔會啟用（v0.9.0 嘅事故）
L=$(unzip -l "$OUT/build/GhostBattles.apk" | awk '{print $4}')
MISS=0
echo "$L" | grep -qx 'assets/native/ACTIVE.txt' || { echo "包內缺 native/ACTIVE.txt"; MISS=1; }
for m in $(grep -oE '[a-z0-9_]+' jsgen/modules.txt); do
	if grep -v '^#' native/ACTIVE.txt | sed 's/[[:space:]]//g' | grep -qx "$m"; then
		echo "$L" | grep -qx "assets/native/$m.gd" || { echo "包內缺 native/$m.gd"; MISS=1; }
	else
		echo "$L" | grep -qx "assets/jsgen/$m.gd" || { echo "包內缺 jsgen/$m.gd"; MISS=1; }
	fi
done
[ $MISS = 0 ] || { echo "包內容檢查唔過，唔交付"; exit 1; }
echo "包內容檢查：通過"

# 用同一套篩選匯出 pck，喺電腦用「包入面嘅檔」跑全遊戲一條龍（唔係用專案資料夾）
if [ -z "$NOPKGTEST" ]; then
	# 測試用 pck：同 APK 一樣嘅篩選（tools/ 有 .gdignore 唔會入包，測試腳本另外抄出嚟用絕對路徑載）
	flock /tmp/godot.lock timeout 900 "$GD" --headless --path . --export-pack Linux "$OUT/build/pkgtest.pck" > "$OUT/build/export_pck.log" 2>&1
	PT="$OUT/pkgrun"; rm -rf "$PT"; mkdir -p "$PT/xdg" "$PT/t"
	cp tools/tests/full_run.gd tools/tests/l3_play.gd tools/tests/l1_pt_play.gd "$PT/t/"
	sed -i "s#res://tools/tests/#$PT/t/#g" "$PT"/t/*.gd
	echo "[[\"wait\",3],[\"gdrun\",\"$PT/t/full_run.gd\",\"all\"],[\"quit\"]]" > "$PT/full.json"
	(cd "$PT" && flock /tmp/godot.lock env XDG_DATA_HOME="$PT/xdg" GB_TEST="$PT/full.json" timeout 600 xvfb-run -a -s '-screen 0 450x975x24' "$GD" --main-pack "$OUT/build/pkgtest.pck" --rendering-driver opengl3 > "$OUT/build/pkgrun.log" 2>&1) || true
	SE=$(grep -c "SCRIPT ERROR" "$OUT/build/pkgrun.log" || true)
	grep -q '\[full\] done' "$OUT/build/pkgrun.log" && DONE=1 || DONE=0
	grep -E '\[full\] (done|save_check)' "$OUT/build/pkgrun.log"
	echo "包內一條龍：腳本錯誤 $SE，完成=$DONE"
	[ "$SE" = 0 ] && [ $DONE = 1 ] || { echo "包內一條龍唔過，唔交付"; exit 1; }
fi
mkdir -p /mnt/user-data/outputs
cp "$OUT/build/GhostBattles.apk" "/mnt/user-data/outputs/GhostBattles_v$VER.apk"
echo "完成：/mnt/user-data/outputs/GhostBattles_v$VER.apk"
