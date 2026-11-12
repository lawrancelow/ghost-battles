#!/bin/bash
# 樓裡有鬼 v10 驗收：bash /tmp/claude-0/qa/run_all.sh [--rebuild]
Q=/tmp/claude-0/qa; L=$Q/logs; mkdir -p $L /tmp/claude-0/out; cd $Q
curl -s -o /dev/null http://127.0.0.1:8765/unit.html || (cd /tmp/claude-0/old && nohup python3 -m http.server 8765 >/dev/null 2>&1 &) ; sleep 1
if [ "$1" == "--rebuild" ]; then bash /tmp/claude-0/ut/rebuild.sh || { echo "FAIL rebuild"; exit 1; }; fi
cp /home/claude/gb/site/index.html /tmp/claude-0/old/new.html
export QA_PAGE=unit.html
rm -f $L/[A-G]_*.log
( node speed.js flat > $L/A_flat.log 2>&1; node speed.js shop > $L/A_shop.log 2>&1; node react.js flat new > $L/C_flat.log 2>&1; node react.js shop new_shop > $L/C_shop.log 2>&1 ) &
( node safe.js flat 3 > $L/B_flat.log 2>&1; node lines.js flat > $L/D_flat.log 2>&1 ) &
( node safe.js shop 3 > $L/B_shop.log 2>&1; node lines.js shop > $L/D_shop.log 2>&1 ) &
( cd /tmp/claude-0/ut; node play.js flat > $L/E_play_flat.log 2>&1; node play.js shop > $L/E_play_shop.log 2>&1; node sim.js flat 3 > $L/E_sim_flat.log 2>&1; node sim.js shop 3 > $L/E_sim_shop.log 2>&1 ) &
wait
( node unitshot.js flat > $L/E_unit_flat.log 2>&1; node unitshot.js shop > $L/E_unit_shop.log 2>&1 ) &
( mkdir -p $L/fshots; cd $L/fshots; for f in prodchk tw st2 mig; do timeout 400 python3 /tmp/claude-0/$f.py > $L/F_$f.log 2>&1; done ) &
wait
python3 $Q/report.py | tee $L/summary.txt
