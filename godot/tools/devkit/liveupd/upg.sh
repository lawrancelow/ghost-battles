#!/bin/bash
# 升級實測：舊底包(b34) → 35（舊 Boot 背景落，要重開一次）→ 36（新開機畫面即場落、即場生效，唔使重開）
N=/tmp/upg; rm -rf $N; mkdir -p $N/xb $N/sh2 $N/sh3 $N/sh5 $N/sh6
T=~/.local/share/godot/export_templates/4.3.stable/linux_debug.x86_64
U="$N/xb/godot/app_userdata/過勞鬼大作戰"
S=/tmp/upgtools
run(){ # run <port> <testjson> <log> [env...]
	local p=$1 j=$2 l=$3; shift 3
	( cd $N; env XDG_DATA_HOME=$N/xb GB_UPDATE_URL=http://127.0.0.1:$p/version.json GB_TEST=$j "$@" timeout ${TO:-900} xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/b34/Linux.pck --rendering-driver opengl3 > $l 2>&1 ); pkill -f "Xvfb :"; sleep 1
	echo "  [$l] SE=$(grep -c 'SCRIPT ERROR' $l) $(grep -E '^\[(boot|launch|marker)\]' $l | grep -v 'mod:' | tr '\n' ' ' | cut -c1-400)"
	echo "  state: $(cat "$U/update/state.json" 2>/dev/null)"; echo "  files: $(ls "$U/update" | tr '\n' ' ')"
}
echo '[["wait",40],["quit"]]' > $N/w40.json
echo '[["wait",4],["shot","/tmp/upg/title.png"],["quit"]]' > $N/w4.json
pkill -f "srv.py" ; sleep 0.5
python3 $S/srv.py $S/s35 8835 0 2>$N/srv35.log &
python3 $S/srv.py $S/s36 8836 12000000 2>$N/srv36.log &
python3 $S/srv.py $S/s36 8837 12000000 30000000 2>$N/srv37.log &
python3 $S/srv.py $S/bad 8838 0 2>$N/srvbad.log &
sleep 1

echo "== 1. 舊底包，伺服器有 35：舊 Boot 背景落，下次開生效"
run 8835 $N/w40.json $N/r1.log
echo "== 2. 重開：載入 35（新開機畫面），查伺服器 35 → 已是最新"
run 8835 $N/w4.json $N/r2.log GB_LAUNCH_SHOTS=$N/sh2
cp -r "$U" $N/snap35
echo "== 3. 伺服器出 36：開機畫面即場下載（限速 12MB/秒）→ 即場生效（唔使重開）"
run 8836 $N/w4.json $N/r3.log GB_LAUNCH_SHOTS=$N/sh3
cp $N/title.png $N/title36.png
echo "== 4. 再開：36 已裝好 → 已是最新"
run 8836 $N/w4.json $N/r4.log
echo "== 5. 斷線續傳：返去 35 狀態，伺服器落到 30MB 斷線一次 → 自動續傳"
rm -rf "$U"; cp -r $N/snap35 "$U"
run 8837 $N/w4.json $N/r5.log GB_LAUNCH_SHOTS=$N/sh5
echo "== 6. 冇網：返去 35 狀態，伺服器唔存在 → 用而家版本照入遊戲"
rm -rf "$U"; cp -r $N/snap35 "$U"
run 8899 $N/w4.json $N/r6.log
echo "== 7. 補丁壞咗（md5 唔啱）→ 自動再試兩次 → 出「重試／先玩」掣（截圖）"
rm -rf "$U"; cp -r $N/snap35 "$U"
echo '[["shot","/tmp/upg/fail.png"],["quit"]]' > $N/fail.json
TO=60 run 8838 $N/fail.json $N/r7.log GB_LAUNCH_SHOTS=$N/sh6
pkill -f "srv.py"
echo UPGDONE
