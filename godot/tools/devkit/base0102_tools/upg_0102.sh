#!/bin/bash
N=/tmp/t47/run; rm -rf $N; mkdir -p $N/xb
T=~/.local/share/godot/export_templates/4.3.stable/linux_debug.x86_64
U="$N/xb/godot/app_userdata/過勞鬼大作戰"
run(){ local p=$1 l=$2; shift 2
 ( cd $N; env XDG_DATA_HOME=$N/xb GB_UPDATE_URL=http://127.0.0.1:$p/version.json GB_TEST=$N/w.json "$@" timeout 600 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/new12/Linux.pck --rendering-driver opengl3 > $l 2>&1 ); sleep 1
 echo "  [$l] SE=$(grep -c 'SCRIPT ERROR' $l) $(grep -E '^\[(boot|launch|marker)\]' $l | grep -v 'mod:' | tr '\n' ' ' | cut -c1-500)"
 echo "  state: $(cat "$U/update/state.json" 2>/dev/null)"; echo "  files: $(ls "$U/update" 2>/dev/null | tr '\n' ' ') | keep: $(cat "$U/keep.txt" 2>/dev/null)"; }
echo '[["wait",6],["shot","/tmp/t47/run/title.png"],["quit"]]' > $N/w.json
python3 /tmp/t47/srv.py /tmp/t47/srv 8847 0 2>$N/srv.log & SP=$!
mkdir -p /tmp/t47/empty; echo '{"base":{"0.10.1":{"linux":{"ver":46,"file":"p_0101_linux_46.pck","md5":"x","size":1}}}}' > /tmp/t47/empty/version.json
python3 /tmp/t47/srv.py /tmp/t47/empty 8848 0 2>$N/srv2.log & SP2=$!
sleep 1
echo "== 1. 舊 0.10.1 裝置覆蓋安裝 0.10.2（舊補丁 46 狀態），伺服器未有 0.10.2 補丁 → 唔落 46、清走舊補丁、照入遊戲"
mkdir -p "$U/update"; echo '{"base":"0.10.1","ver":46,"file":"p_0101_linux_46.pck","lv":46}' > "$U/update/state.json"; echo dummy > "$U/update/p_0101_linux_46.pck"; echo "我的存檔" > "$U/keep.txt"
run 8848 $N/r1.log
echo "== 2. 伺服器出 0.10.2 補丁 47 → 開機即場落、即場生效（marker p47）"
run 8847 $N/r2.log GB_LAUNCH_SHOTS=$N/sh2
echo "== 3. 再開：已是最新，唔重複落"
run 8847 $N/r3.log
kill $SP $SP2; echo UPGDONE
