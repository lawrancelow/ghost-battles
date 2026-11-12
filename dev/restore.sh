#!/bin/bash
# 新對話還原開發環境：bash /home/claude/ghost-battles/dev/restore.sh
set -e
R=/home/claude/ghost-battles/dev
mkdir -p /home/claude/gb /home/claude/lyg /tmp/claude-0/old /tmp/claude-0/out
cp -r $R/src $R/tools $R/build.py /home/claude/gb/
[ -d $R/art ] && cp -r $R/art /home/claude/gb/ || true
cp -r $R/lyg/. /home/claude/lyg/
cp -r $R/tests/qa $R/tests/ut $R/tests/ut_gp $R/tests/gpt /tmp/claude-0/ 2>/dev/null || true
cp $R/tests/*.py /tmp/claude-0/ 2>/dev/null || true
cp $R/tests/compensation_save_code.txt /tmp/claude-0/save_code.txt
cd /home/claude/gb && python3 build.py | tail -1
echo "還原完成。樓裡有鬼全鏈重建：bash /tmp/claude-0/ut/rebuild.sh"
