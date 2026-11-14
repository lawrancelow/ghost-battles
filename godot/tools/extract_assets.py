# 把 gb/src/*.js 入面嘅 base64 圖抽出做獨立 .webp，並輸出「去圖版」源碼（data URI 換成 res:// 路徑）
import re,os,sys,base64,json,hashlib
SRC=sys.argv[1]; OUT=sys.argv[2]  # OUT = godot 專案根
os.makedirs(OUT+'/assets/img',exist_ok=True); os.makedirs(OUT+'/../gbgd_ref',exist_ok=True)
pat=re.compile(r'data:(image/(webp|png|jpeg|gif));base64,([A-Za-z0-9+/=]+)')
keypat=re.compile(r"""(?:k\s*:\s*'([\w]+)'[^{}]*?$)|(?:\[\s*["']([\w]+)["']\s*\]\s*=\s*$)|(?:["']?([\w]+)["']?\s*:\s*(?:\{\s*src\s*:\s*)?$)|(?:\.([\w]+)\s*=\s*$)""")
man={}; total=0
for f in sorted(os.listdir(SRC)):
    if not f.endswith('.js'): continue
    s=open(SRC+'/'+f,encoding='utf8').read()
    if 'base64,' not in s:
        open(OUT+'/../gbgd_ref/'+f,'w').write(s); continue
    grp=f[:-3]; used={}
    def rep(m):
        global total
        st=m.start()-1
        q=s[st]  # 引號
        before=s[max(0,st-300):st]
        km=None
        for mm in keypat.finditer(before): km=mm
        key=next((g for g in (km.groups() if km else ()) if g),None) or 'img'
        n=used.get(key,0); used[key]=n+1
        name=key if n==0 else f'{key}_{n}'
        ext=m.group(2)
        data=base64.b64decode(m.group(3))
        p=f'assets/img/{grp}/{name}.{ext}'
        os.makedirs(os.path.dirname(OUT+'/'+p),exist_ok=True)
        open(OUT+'/'+p,'wb').write(data); total+=len(data)
        man[f'{grp}:{name}']=p
        return 'res://'+p
    s2=pat.sub(rep,s)
    open(OUT+'/../gbgd_ref/'+f,'w').write(s2)
json.dump(man,open(OUT+'/assets/img_manifest.json','w'),ensure_ascii=False,indent=0)
print(len(man),'images',total//1024,'KB')
