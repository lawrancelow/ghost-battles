#!/bin/bash
G=/home/claude/ghost-battles/godot
run(){ /home/claude/setup/edtest.sh $G $1 $2 $3 1200; }   # edtest 自己清自己嘅 Xvfb
run fogfix res://tools/tests/fogfix_test.gd all
run zone res://tools/tests/zone_test.gd all
run zstory res://tools/tests/zstory_test.gd logic
run storyhook res://tools/tests/storyhook_test.gd all
run mapbattle res://tools/tests/mapbattle_test.gd logic
run unify res://tools/tests/unify_test.gd logic
run village res://tools/tests/village_test.gd all
run village2 res://tools/tests/village2_test.gd logic
run mv res://game/outpost/mv_test.gd logic
run gift res://tools/tests/gift_test.gd all
run namefix res://tools/tests/namefix_test.gd all
run chain res://tools/tests/chain_test.gd logic
run chainui res://tools/tests/chainui_test.gd logic
run war res://tools/tests/war_test.gd logic
run idle res://tools/tests/idle_test.gd logic
run play res://tools/tests/play_test.gd logic
run motion res://tools/tests/motion_test.gd logic
run mist res://tools/tests/mist_test.gd logic
run mvi res://tools/tests/mvi_test.gd all
run joss res://tools/tests/joss_test.gd all
run pace res://tools/tests/pace_test.gd logic
run paddy res://tools/tests/paddyfix_test.gd logic
echo ALLDONE
