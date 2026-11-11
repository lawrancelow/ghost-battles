s=open('/home/claude/gb/GhostBattles.html',encoding='utf-8').read()
a="const SAVE_KEY = 'ghostBattles_v1';"; assert a in s
s=s.replace(a,"window.STN_TEST = 1; const SAVE_KEY = 'ghostBattles_stntest';",1)
b="if (IS_FILE && !navigator.webdriver"; assert b in s; s=s.replace(b,"if (false && IS_FILE && !navigator.webdriver",1)
s=s.replace('<title>','<title>（樓裡有鬼測試）',1)
open('/tmp/claude-0/out/GhostBattles_TowerTest.html','w',encoding='utf-8').write(s); print(len(s))
