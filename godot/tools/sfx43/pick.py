import json,shutil,os,sys
DEF={'sub_heal':'C','ace_bless':'C','fuse':'C','star':'C','eq_set':'C','eq_ex':'C','boss_capture':'C','soul_drop':'C','mvp':'C'}
m=json.load(open('/home/claude/audio/out/cand_meta.json'))
dst=sys.argv[1]; os.makedirs(dst,exist_ok=True)
for k in m:
    c=DEF.get(k,'A')
    shutil.copy('/home/claude/audio/out/cand/%s__%s.ogg'%(k,c),'%s/%s.ogg'%(dst,k))
    m[k]['default']=c
json.dump(m,open('/home/claude/audio/out/cand_meta.json','w'),ensure_ascii=False,indent=1)
print(len(m))
