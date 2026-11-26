import sys,json,os
sys.path.insert(0,'/home/claude/audio/tools')
from mk import build,save,SR
from recipes import RC
out='/home/claude/audio/out/cand'; meta={}
only=sys.argv[1:]
for k,v in RC.items():
    if only and k not in only: continue
    meta[k]={'cat':v['cat'],'where':v['where'],'c':[]}
    for name,desc,layers,opt in v['c']:
        m,srcs=build(layers,**opt)
        p='%s/%s__%s.ogg'%(out,k,name); save(m,p)
        meta[k]['c'].append({'id':name,'desc':desc,'file':os.path.basename(p),'dur':round(len(m)/SR,2),'src':srcs})
        print(k,name,round(len(m)/SR,2))
if not only: json.dump(meta,open('/home/claude/audio/out/cand_meta.json','w'),ensure_ascii=False,indent=1)
