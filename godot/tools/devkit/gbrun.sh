#!/bin/bash
# gbrun.sh <command...>：任何要開 Godot/Xvfb 嘅指令都經呢個排隊（多線並行時唔會互殺）
# 只清自己進程組嘅 Xvfb（唔好 pkill -f "Xvfb :"，會誤殺其他組）
( flock 9; setsid "$@" & XP=$!; wait $XP; RC=$?; kill -TERM -- -$XP 2>/dev/null; sleep 1; kill -KILL -- -$XP 2>/dev/null; exit $RC ) 9>/tmp/gbtest.flock
