#!/bin/bash
# gbrun.sh <command...>：任何要開 Godot/Xvfb 嘅指令都經呢個排隊（多線並行時唔會互殺）
( flock 9; "$@"; pkill -f "Xvfb :"; sleep 1 ) 9>/tmp/gbtest.flock
