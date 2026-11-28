#!/bin/bash
# gbslot.sh <命令…>：全機最多 2 個 Godot 並行，先到先得（排號制）。
Q=/tmp/gbslot.q; mkdir -p $Q
T=$(date +%s%N).$$; touch $Q/$T
trap 'rm -f $Q/$T' EXIT
while :; do
  # 清掉已死進程留下的號
  for f in $Q/*; do p=${f##*.}; kill -0 "$p" 2>/dev/null || rm -f "$f"; done
  head=$(ls $Q | sort | head -1)
  if [ "$head" = "$T" ]; then
    for i in 1 2; do
      exec 8>/tmp/gbslot.$i.lock
      if flock -n 8; then rm -f $Q/$T; GB_LOCK=/tmp/gbtest.$i.flock "$@"; exit $?; fi
    done
  fi
  sleep 2
done
