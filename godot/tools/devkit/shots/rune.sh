#!/bin/bash
# run.sh <tag> [half]
PT=/tmp/edt/$1; rm -rf $PT; mkdir -p $PT/x
echo '[["wait",3],["gdrun","/tmp/bs/e.gd","all"],["quit"]]' > $PT/t.json
cd /home/claude/ghost-battles/godot && env BS_OUT=/tmp/bs/$1 BS_HALF=${2:-0} XDG_DATA_HOME=$PT/x GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/t.json timeout 300 xvfb-run -a -s '-screen 0 900x1950x24' /opt/godot/Godot_v4.3-stable_linux.x86_64 --path . --rendering-driver opengl3 --resolution 900x1950 > $PT/log 2>&1
echo "exit=$? err=$(grep -c 'SCRIPT ERROR' $PT/log)"; grep -E '\[bs\]|SCRIPT ERROR' -A2 $PT/log | cut -c1-900 | head -12; ls /tmp/bs/$1
