set -e
python3 /home/claude/lyg/tools/patch_v5.py >/dev/null
python3 /home/claude/gb/tools/port_tower.py >/dev/null
[ -f /home/claude/gb/tools/port_tower_tiles.py ] && python3 /home/claude/gb/tools/port_tower_tiles.py >/dev/null
cd /home/claude/gb && python3 build.py >/dev/null
python3 - <<'P'
s=open('/home/claude/gb/GhostBattles.html',encoding='utf-8').read()
a="const SAVE_KEY = 'ghostBattles_v1';"; b="if (IS_FILE && !navigator.webdriver"
assert s.count(a)==1 and s.count(b)==1
s=s.replace(a,"const SAVE_KEY = 'ghostBattles_stntest'; window.STN_TEST = 1;").replace(b,"if (false && IS_FILE && !navigator.webdriver")
open('/tmp/claude-0/old/unit.html','w',encoding='utf-8').write(s); print('rebuilt')
P
