#!/bin/bash
# 由老闆嘅 GhostBattles_v0.10.1.apk 重建 0.10.1 Linux 底包 pck（APK 入面係散檔，冇 pck）
# 用法：base_from_apk.sh <apk>
set -e; A=$1; O=/tmp/apk101; mkdir -p $O; cp "$A" $O/base.apk; cd $O; rm -rf x; unzip -q base.apk 'assets/*' -d x
cd x/assets && python3 -c "
import os,json;L=[]
for r,d,f in os.walk('.'):
  for n in f: p=os.path.join(r,n)[2:]; L.append(['res://'+p,os.path.abspath(p)])
json.dump(L,open('$O/base_list.json','w'))"
/opt/godot/Godot_v4.3-stable_linux.x86_64 --headless -s /home/claude/ghost-battles/godot/tools/update/make_pck.gd -- $O/base_list.json $O/Linux.pck
cp /home/claude/setup/base_0101/*.json $O/
