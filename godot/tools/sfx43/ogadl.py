# 下載 OGA CC0 素材：驗證授權＝CC0（唯一授權）先下載；記錄 json
import sys,re,urllib.request,json,os
def get(u,b=False):
    r=urllib.request.Request(u,headers={'User-Agent':'Mozilla/5.0'})
    d=urllib.request.urlopen(r,timeout=120).read()
    return d if b else d.decode('utf8','replace')
out=sys.argv[1]; rec=json.load(open(out+'/sources.json')) if os.path.exists(out+'/sources.json') else {}
for slug in sys.argv[2:]:
    u='https://opengameart.org/content/'+slug
    t=get(u)
    lic=re.findall(r"license-name'>([^<]+)",t)
    m=re.search(r'field-name-author-submitter.*?<a href="/users/[^"]+">([^<]+)</a>',t,re.S)
    au=m.group(1) if m else '?'
    m2=re.search(r'field-name-field-art-attribution.*?field-item even">(.*?)</div>',t,re.S)
    attr=re.sub('<[^>]+>','',m2.group(1)).strip() if m2 else ''
    title=re.findall(r'<title>([^<|]+)',t)[0].strip()
    if lic!=['CC0']: print('SKIP',slug,lic); continue
    files=sorted(set(re.findall(r'href="(https://opengameart.org/sites/default/files/[^"]+)"',t)))
    files=[f for f in files if re.search(r'\.(zip|7z|wav|ogg|flac|mp3)$',f,re.I)]
    d=out+'/'+slug; os.makedirs(d,exist_ok=True)
    for f in files:
        fn=d+'/'+os.path.basename(f)
        if not os.path.exists(fn): open(fn,'wb').write(get(f,True))
    rec[slug]={'title':title,'url':u,'author':au,'attr':attr,'license':'CC0 1.0','license_url':'https://creativecommons.org/publicdomain/zero/1.0/','files':files}
    print('OK',slug,au,len(files))
json.dump(rec,open(out+'/sources.json','w'),ensure_ascii=False,indent=1)
