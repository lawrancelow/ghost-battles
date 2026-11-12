#!/bin/bash
# 轉譯全部模塊：ref（去圖版源碼）→ 套 patches.js → jsgd.js → godot/jsgen/*.gd
set -e
cd "$(dirname "$0")"
# 需要：npm i acorn；源碼 ../ref（由 tools/extract_assets.py 生成嘅去圖版）
mkdir -p /tmp/jsgd_src ../godot/jsgen
node -e '
const fs=require("fs"),P=require("./patches.js");
for(const m of fs.readFileSync("modules.txt","utf8").split("\n").filter(Boolean)){
  let s=fs.readFileSync("../ref/"+m+".js","utf8");
  for(const [a,b] of (P[m]||[])){ if(!s.includes(a)){console.error("PATCH MISS",m,a.slice(0,50));process.exit(1);} s=s.split(a).join(b); }
  fs.writeFileSync("/tmp/jsgd_src/"+m+".js",s);
}'
fails=0
for m in $(cat modules.txt); do node jsgd.js /tmp/jsgd_src/$m.js ../godot/jsgen/$m.gd $m > /tmp/tr_$m.log 2>&1 || { fails=$((fails+1)); echo "FAIL $m"; tail -3 /tmp/tr_$m.log; }; done
echo "transpile fails=$fails"
