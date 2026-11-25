T=~/.local/share/godot/export_templates/4.3.stable/linux_debug.x86_64; PT=/tmp/v35; rm -rf $PT; mkdir -p $PT/xa $PT/xb $PT/t; SRC=/home/claude/ghost-battles/godot/tools/tests; cp $SRC/full_run.gd $SRC/l3_play.gd $SRC/l1_pt_play.gd $PT/t/; sed -i "s#res://tools/tests/#$PT/t/#g" $PT/t/*.gd
echo "[[\"wait\",3],[\"gdrun\",\"$PT/t/full_run.gd\",\"all\"],[\"quit\"]]" > $PT/full.json; echo '[["wait",420],["quit"]]' > $PT/st.json
cd $PT; env XDG_DATA_HOME=$PT/xb GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_SELFTEST=1 GB_TEST=$PT/st.json timeout 600 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/b35/Linux.pck --rendering-driver opengl3 > $PT/st.log 2>&1; pkill -f "Xvfb :"
F=$(find $PT/xb -name selftest.json | head -1); python3 -c "import json; d=json.load(open('$F')); r=d.get('res',{}); print('selftest', len(r), {k:v for k,v in r.items() if not str(v).startswith('OK') and k!='info'})"; echo "SE $(grep -c 'SCRIPT ERROR' $PT/st.log)"
env XDG_DATA_HOME=$PT/xa GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/full.json timeout 1500 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/b35/Linux.pck --rendering-driver opengl3 > $PT/full.log 2>&1; pkill -f "Xvfb :"; grep "\[full\] done" $PT/full.log; echo "full SE $(grep -c 'SCRIPT ERROR' $PT/full.log)"
# 即場更新之後跑自檢：35 狀態 → 伺服器 36 → 開機畫面即場裝 36 → 自檢
N=/tmp/upg; U="$N/xb/godot/app_userdata/過勞鬼大作戰"; rm -rf "$U"; cp -r $N/snap35 "$U"; rm -f "$U/selftest.json" "$U"/selftest_done_*
(python3 /tmp/upgtools/srv.py /tmp/upgtools/s36 8836 0 2>/dev/null &) ; sleep 1
cd $N; env XDG_DATA_HOME=$N/xb GB_UPDATE_URL=http://127.0.0.1:8836/version.json GB_SELFTEST=1 GB_TEST=$PT/st.json timeout 600 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/b34/Linux.pck --rendering-driver opengl3 > $N/st36.log 2>&1; pkill -f "Xvfb :"; pkill -f srv.py
python3 -c "import json; d=json.load(open('$U/selftest.json')); r=d.get('res',{}); print('selftest-after-inplace', len(r), {k:v for k,v in r.items() if not str(v).startswith('OK') and k!='info'})"; echo "SE36 $(grep -c 'SCRIPT ERROR' $N/st36.log)"; grep "\[launch\]\|\[marker\]" $N/st36.log | head
echo STDONE
