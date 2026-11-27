import os,sys,glob,subprocess,json,numpy as np
sys.path.insert(0,'/home/claude/sfxwork'); from map import M
SR=44100
ROOTS={'kenney':'/home/claude/sfxsrc/kenney-audio-assets/Audio (295 files)/RPG sounds (50 sounds)'}
OGA='/home/claude/sfxsrc/oga'
HINT={'80rpg':'80-cc0-rpg-sfx','40cc0':'40-cc0-water-splash-slime-sfx','mw':'100-cc0-metal-and-wood-sfx','action':'action-sounds','skippy':'skippy-fish-water-sound-collection'}
idx=[]
for p in glob.glob(ROOTS['kenney']+'/*.ogg'): idx.append(('kenney',p))
for p in glob.glob(OGA+'/**/*',recursive=True):
    if os.path.isfile(p) and p.lower().endswith(('.wav','.ogg','.mp3','.flac')) and not os.path.basename(p).startswith('._'):
        idx.append((p[len(OGA)+1:].split('/')[0],p))
def resolve(spec):
    off=0.0
    if '@' in spec: spec,o=spec.rsplit('@',1); off=float(o)
    pack=None
    if '/' in spec: h,spec=spec.split('/',1); pack=HINT.get(h,h)
    c=[(k,p) for k,p in idx if os.path.basename(p)==spec and (pack is None or k==pack)]
    # 同名多格式：揀最先（ogg 優先 wav）
    if not c: raise SystemExit('NOT FOUND '+spec)
    packs={k for k,_ in c}
    if len(packs)>1: raise SystemExit(f'AMBIG {spec} {packs}')
    return c[0][0],c[0][1],off
def load(p,off,dur):
    r=subprocess.run(['ffmpeg','-v','error','-ss',str(off),'-t',str(dur+3),'-i',p,'-ac','1','-ar',str(SR),'-f','f32le','-'],capture_output=True)
    return np.frombuffer(r.stdout,np.float32).copy()
def eerie(x):
    # 降約 3 個半音（重採樣），短殘響，輕低通
    r=2**(-3/12); n=int(len(x)/r); x=np.interp(np.arange(n)*r,np.arange(len(x)),x).astype(np.float32)
    y=x.copy()
    for d,g in [(0.043,0.32),(0.071,0.22),(0.113,0.14),(0.167,0.08)]:
        k=int(d*SR); y[k:]+=g*x[:-k]
    a=np.exp(-2*np.pi*5200/SR); z=np.empty_like(y); s=0.0
    for i,v in enumerate(y): s=(1-a)*v+a*s; z[i]=s
    return z
ONE={'chop','hack','split','poke','pound','wok','forge','stamp','tongs','catch','slice','screw','knead','pick','fork','fold'}
def proc(x,maxd,ee,oneshot=False):
    if len(x)==0: raise SystemExit('EMPTY')
    sm=np.sqrt(np.convolve(x**2,np.ones(441)/441,'same'))
    on=int(np.argmax(sm>sm.max()*0.3)); on=max(0,on-int(0.012*SR)); x=x[on:]
    if oneshot:
        sm=np.sqrt(np.convolve(x**2,np.ones(441)/441,'same')); pk=int(np.argmax(sm[:int(0.25*SR)])); hp=sm[pk]
        below=sm<hp*0.06; run=0; cut=len(x)
        for i in range(pk,len(x)):
            run=run+1 if below[i] else 0
            if run>int(0.04*SR): cut=i; break
        x=x[:cut]
    if ee: x=eerie(x)
    L=int(maxd*SR); x=x[:L]
    # 尾部：過了主體後低於 -45dB 就切
    e=np.sqrt(np.convolve(x**2,np.ones(441)/441,'same')); pk=e.max()
    tail=np.where(e>pk*0.006)[0]; end=min(len(x),tail[-1]+int(0.02*SR)) if len(tail) else len(x); x=x[:end]
    fi=int(0.003*SR); fo=min(int(0.06*SR),len(x)//3)
    x[:fi]*=np.linspace(0,1,fi); x[-fo:]*=np.linspace(1,0,fo)**2
    # 響度：主體 RMS 統一到 -20 dBFS，峰值限 -1 dBFS
    act=e[:len(x)]>pk*0.1; rms=np.sqrt(np.mean(x[act]**2)) if act.any() else np.sqrt(np.mean(x**2))
    x*=10**(-20/20)/max(rms,1e-6); p=np.abs(x).max()
    if p>10**(-1/20): x*=10**(-1/20)/p
    return x.astype(np.float32)
def enc(x,out):
    for ext,args in [('.ogg',['-c:a','libvorbis','-q:a','5']),('.mp3',['-c:a','libmp3lame','-q:a','3'])]:
        subprocess.run(['ffmpeg','-v','error','-y','-f','f32le','-ar',str(SR),'-ac','1','-i','-']+args+[out+ext],input=x.tobytes(),check=True)
OUT='/home/claude/sfxwork/out'; os.makedirs(OUT,exist_ok=True)
rec=[]
for ev,(zh,maxd,srcs) in M.items():
    for lab,spec in zip('ABC',srcs):
        ee=spec.startswith('E:'); s=spec[2:] if ee else spec
        pack,path,off=resolve(s)
        x=proc(load(path,off,maxd+1.5),maxd+(0.15 if ee else 0),ee,ev.split('_')[1] in ONE)
        fn=f'{ev}_{lab}'; enc(x,f'{OUT}/{fn}')
        rec.append({'event':ev,'zh':zh,'cand':lab,'file':fn+'.ogg','dur':round(len(x)/SR,3),'eerie':ee,'pack':pack,'src':os.path.relpath(path, OGA if pack!='kenney' else ROOTS['kenney']),'offset':off,
          'url':('https://kenney.nl/assets/rpg-audio （經 GitHub 鏡像 ismetcabbar9-oss/kenney-audio-assets）' if pack=='kenney' else 'https://opengameart.org/content/'+pack),'license':'CC0 1.0'})
json.dump(rec,open(OUT+'/sources.json','w'),ensure_ascii=False,indent=1)
print(len(rec),'files'); 
for r in rec:
    if r['dur']<0.08: print('SHORT',r['event'],r['cand'],r['dur'])
