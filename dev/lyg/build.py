import base64, json, os
D=os.path.dirname(os.path.abspath(__file__))
keys=['eguiking','toyol','tianhua','tianhua_hang','npc_ken','npc_ken_sit','npc_auntie','npc_guard','npc_it','npc_it_sit','npc_mis','npc_boss']
img={k:'data:image/webp;base64,'+base64.b64encode(open(f'{D}/assets/{k}.webp','rb').read()).decode() for k in keys}
s=open(f'{D}/src/shell.html',encoding='utf-8').read()
rd=lambda n: open(f'{D}/src/{n}',encoding='utf-8').read()
s=s.replace('/*IMG*/','window.LYG_IMG='+json.dumps(img)+';').replace('/*DATA*/',rd('data.js')).replace('/*SIM*/',rd('sim.js')).replace('/*GAME*/',rd('game.js'))
open(f'{D}/GhostTower.html','w',encoding='utf-8').write(s)
print('built',len(s))
