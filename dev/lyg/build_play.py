import base64, json, os
D=os.path.dirname(os.path.abspath(__file__))
keys=['room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby','res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym','npc_it_sit','npc_ken_sit','eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_auntie','npc_guard','npc_it','npc_mis','npc_boss','flatbg','shopbg']
img={k:'data:image/webp;base64,'+base64.b64encode(open(f'{D}/assets/{k}.webp','rb').read()).decode() for k in keys}
s=open(f'{D}/src/shell.html',encoding='utf-8').read().replace('<title>楼里有鬼</title>','<title>樓裡有鬼・組屋關</title>').replace('lang="zh-CN"','lang="zh-HK"')
s=s.replace('/*IMG*/','window.LYG_IMG='+json.dumps(img)+';').replace('/*DATA*/','').replace('/*SIM*/',open(f'{D}/core/lift.js',encoding='utf-8').read()).replace('/*GAME*/',open(f'{D}/src/pangsa.js',encoding='utf-8').read())
os.makedirs('/tmp/claude-0/out',exist_ok=True)
open('/tmp/claude-0/out/GhostTower_Play.html','w',encoding='utf-8').write(s); print('built',len(s))
