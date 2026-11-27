#!/bin/bash
# acct_edtest.sh <godotdir> <tag> <script> <func> <timeout> <WxH>
D=$1; TAG=$2; S=$3; A=$4; TO=${5:-900}; R=${6:-450x975}
PT=/tmp/edt/$TAG; rm -rf $PT; mkdir -p $PT/x
echo "[[\"wait\",3],[\"gdrun\",\"$S\",\"$A\"],[\"quit\"]]" > $PT/t.json
cd $D && ( flock 9; env GB_ACCT_GATE=1 XDG_DATA_HOME=$PT/x GB_UPDATE_URL=http://127.0.0.1:8799/none.json GB_TEST=$PT/t.json timeout $TO xvfb-run -a -s "-screen 0 ${R}x24" /opt/godot/Godot_v4.3-stable_linux.x86_64 --path . --rendering-driver opengl3 --resolution $R > $PT/log 2>&1; sleep 1 ) 9>/tmp/gbtest.flock
echo "== $TAG  SCRIPT_ERR=$(grep -c 'SCRIPT ERROR' $PT/log)  $(grep -E 'RESULT' $PT/log | tail -2 | tr '\n' ' ')"
