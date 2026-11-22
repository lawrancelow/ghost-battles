N=/tmp/v58u; rm -rf $N; mkdir -p $N/xb; cd $N
T=~/.local/share/godot/export_templates/4.3.stable/linux_debug.x86_64
U="$N/xb/godot/app_userdata/過勞鬼大作戰"
echo '[["wait",120],["quit"]]' > a.json; echo '[["wait",360],["quit"]]' > b.json
run(){ env XDG_DATA_HOME=$N/xb GB_UPDATE_URL=http://127.0.0.1:$1/version.json $3 GB_TEST=$N/$2 timeout 600 xvfb-run -a -s '-screen 0 450x975x24' $T --main-pack /tmp/apk101/Linux.pck --rendering-driver opengl3; pkill -f "Xvfb :"; }
(cd /tmp/srv22 && python3 -m http.server 8822 >$N/h22.log 2>&1 &)
(cd /home/claude/wt/main/godot-update && python3 -m http.server 8823 >$N/h23.log 2>&1 &); sleep 2
echo "== base→22"; run 8822 a.json "" > r1.log 2>&1; cat "$U/update/state.json"; echo
run 8822 a.json "" > r1b.log 2>&1; echo "SE22 $(grep -c 'SCRIPT ERROR' r1b.log)"
echo "== 22→23"; run 8823 a.json "" > r2.log 2>&1; cat "$U/update/state.json"; echo
rm -f "$U/selftest.json" "$U"/selftest_done_*
run 8823 b.json "GB_SELFTEST=1" > r3.log 2>&1
python3 -c "import json; d=json.load(open('$U/selftest.json')); r=d.get('res',{}); print('selftest', len(r), {k:v for k,v in r.items() if not str(v).startswith('OK') and k!='info'})"
echo "SE23 $(grep -c 'SCRIPT ERROR' r3.log)"; grep -o "content[^,]*" r3.log | tail -2
pkill -f "http.server 882"; echo UPGDONE
