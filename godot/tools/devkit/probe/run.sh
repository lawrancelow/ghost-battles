PT=/tmp/edt/probe; rm -rf $PT; mkdir -p $PT/x
echo '[["wait",3],["gdrun","/tmp/probe/p.gd","all"],["quit"]]' > $PT/t.json
cd /home/claude/ghost-battles/godot && env BS_OUT=/tmp/probe/shots XDG_DATA_HOME=$PT/x GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/t.json timeout 400 xvfb-run -a -s '-screen 0 450x975x24' /opt/godot/Godot_v4.3-stable_linux.x86_64 --path . --rendering-driver opengl3 --resolution 450x975 > $PT/log 2>&1
echo "exit=$? err=$(grep -c 'SCRIPT ERROR' $PT/log)"; grep -E '\[probe\]|SCRIPT ERROR' -A1 $PT/log | grep -v '^--' | cut -c1-300 | head -120
