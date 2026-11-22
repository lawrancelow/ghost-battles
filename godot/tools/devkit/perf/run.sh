#!/bin/bash
# run.sh <godot目錄> <tag> [smooth=0/1]：外面要包 bash /home/claude/setup/gbrun.sh
D=$1; TAG=$2; PT=/tmp/perfw/$TAG; rm -rf $PT; mkdir -p $PT/x
echo '[["wait",3],["gdrun","res://tools/devkit/perf/pp.gd","all"],["quit"]]' > $PT/t.json
cd $D && env GB_PROF=${GBP:-} PF_QUICK=${PFQ:-0} PF_SMOOTH=${3:-0} BS_OUT=$PT XDG_DATA_HOME=$PT/x GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/t.json timeout 500 xvfb-run -a -s '-screen 0 450x975x24' /opt/godot/Godot_v4.3-stable_linux.x86_64 --path . --rendering-driver opengl3 --resolution 450x975 > $PT/log 2>&1
echo "exit=$? err=$(grep -c 'SCRIPT ERROR' $PT/log)"; grep -E '\[pf\]|SCRIPT ERROR' -A1 $PT/log | grep -v '^--' | cut -c1-300
