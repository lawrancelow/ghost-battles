#!/bin/bash
# 升級實測：update_test.sh <上一版 xb 目錄> <新目錄>   例：update_test.sh /tmp/v41 /tmp/v43
# 需要：/tmp/apk101/Linux.pck（0.10.1 底包）、/home/claude/wt/main/godot-update 已有新補丁
PREV=$1; NEW=$2; rm -rf $NEW && mkdir -p $NEW && cp -r $PREV/xb $NEW/xb
echo '[["wait",90],["quit"]]' > $NEW/a.json; echo '[["wait",360],["quit"]]' > $NEW/b.json
U="$NEW/xb/godot/app_userdata/過勞鬼大作戰"; rm -f "$U/selftest.json" "$U"/selftest_done_*
(cd /home/claude/wt/main/godot-update && python3 -m http.server 8811 >$NEW/http.log 2>&1 &); sleep 2
T=~/.local/share/godot/export_templates/4.3.stable/linux_debug.x86_64; cd $NEW
env XDG_DATA_HOME=$NEW/xb GB_UPDATE_URL=http://127.0.0.1:8811/version.json GB_TEST=$NEW/a.json timeout 300 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/apk101/Linux.pck --rendering-driver opengl3 > r1.log 2>&1; pkill -f "Xvfb :"
cat "$U/update/state.json"; echo
env XDG_DATA_HOME=$NEW/xb GB_UPDATE_URL=http://127.0.0.1:8811/version.json GB_SELFTEST=1 GB_TEST=$NEW/b.json timeout 600 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/apk101/Linux.pck --rendering-driver opengl3 > r2.log 2>&1; pkill -f "Xvfb :"
python3 -c "import json; d=json.load(open('$U/selftest.json')); r=d.get('res',{}); print('selftest', len(r), {k:v for k,v in r.items() if not str(v).startswith('OK') and k!='info'})"
echo "SE $(grep -c 'SCRIPT ERROR' r2.log)"; pkill -f "http.server 8811"; true
