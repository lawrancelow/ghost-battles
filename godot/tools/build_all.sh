#!/bin/bash
# 過勞鬼大作戰 Godot 版：一鍵重生數據／素材＋導出全平台
# 用法：bash godot/tools/build_all.sh [web|android|windows|macos|ios|all]（預設 all）
# 前提：/home/claude/gb（網頁版源碼，restore.sh 還原）、/opt/godot（Godot 4.3＋導出模板）、/opt/android/sdk（Android）
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
PROJ=$(dirname "$HERE")
GB=${GB:-/home/claude/gb}
GODOT=${GODOT:-/opt/godot/Godot_v4.3-stable_linux.x86_64}
OUT=${OUT:-/home/claude/gbgd/build}
WHAT=${1:-all}

echo "== 1. 由網頁版重生數據（跑正式版網頁，等所有模塊補丁打完再導出）"
cp "$GB/site/index.html" /tmp/claude-0/old/new.html
(pgrep -f "http.server 8765" >/dev/null) || (cd /tmp/claude-0/old && nohup python3 -m http.server 8765 >/tmp/http.log 2>&1 &)
sleep 1
python3 "$HERE/dump_runtime.py" "http://127.0.0.1:8765/new.html?local" "$PROJ/data/core.json"
node "$HERE/dump_rigs.js" "$GB/src" "$PROJ/data"

echo "== 2. 素材（SPR_SRC / BG_SRC → assets/spr）"
node "$HERE/dump_spr.js" "$GB/src" "$PROJ"

echo "== 3. 匯入"
timeout 1200 "$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1 || true

exp() { mkdir -p "$(dirname "$3")"; timeout 1200 "$GODOT" --headless --path "$PROJ" $1 "$2" "$3" 2>&1 | grep -E "ERROR" || true; }
[[ $WHAT == all || $WHAT == web ]] && exp --export-release Web "$OUT/web/index.html"
[[ $WHAT == all || $WHAT == android ]] && exp --export-debug Android "$OUT/android/GhostBattles.apk"
[[ $WHAT == all || $WHAT == windows ]] && exp --export-release Windows "$OUT/windows/GhostBattles.exe"
[[ $WHAT == all || $WHAT == macos ]] && exp --export-release macOS "$OUT/macos/GhostBattles.zip"
[[ $WHAT == all || $WHAT == ios ]] && exp --export-release iOS "$OUT/ios/GhostBattles.ipa"
ls -la "$OUT"/*/ 2>/dev/null | grep -E "\.(apk|exe|zip|pck|wasm)$" || true
echo "== 完成"
