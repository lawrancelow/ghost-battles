# 去重：assets/img/** 入面同 assets/spr/* 一模一樣（md5）嘅圖刪走（連 .import），
# 舊路徑寫入 data/img_alias.json（ImgAlias.resolve 會轉去 spr 嗰份）。可以重複跑。
# 用法：python3 tools/dedup_img.py <godot 專案根> [--dry]
import os,sys,json,hashlib
ROOT=sys.argv[1] if len(sys.argv)>1 and not sys.argv[1].startswith('--') else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DRY='--dry' in sys.argv
def md5(p): return hashlib.md5(open(p,'rb').read()).hexdigest()
spr={}
for f in sorted(os.listdir(ROOT+'/assets/spr')):
    if f.endswith('.import') or f.endswith('.json'): continue
    spr.setdefault(md5(ROOT+'/assets/spr/'+f),'res://assets/spr/'+f)
ap=ROOT+'/data/img_alias.json'
alias=json.load(open(ap)) if os.path.exists(ap) else {}
# 舊別名：目標仲喺度、而舊路徑冇再被寫返出嚟先保留
alias={k:v for k,v in alias.items() if os.path.exists(ROOT+'/'+v[6:])}
n=0; saved=0
for d,_,fs in os.walk(ROOT+'/assets/img'):
    for f in fs:
        if f.endswith('.import'): continue
        p=os.path.join(d,f); h=md5(p)
        if h not in spr: 
            alias.pop('res://'+os.path.relpath(p,ROOT).replace(os.sep,'/'),None); continue
        rp='res://'+os.path.relpath(p,ROOT).replace(os.sep,'/')
        alias[rp]=spr[h]; n+=1; saved+=os.path.getsize(p)
        if not DRY:
            os.remove(p)
            if os.path.exists(p+'.import'): os.remove(p+'.import')
if not DRY:
    json.dump(dict(sorted(alias.items())),open(ap,'w'),ensure_ascii=False,indent=0)
print(f'dedup: {n} 個重複圖{"（試跑）" if DRY else "已刪"}，{saved//1024} KB；別名 {len(alias)} 條')
