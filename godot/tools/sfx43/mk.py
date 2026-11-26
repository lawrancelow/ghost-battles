# 音效組合器：只用 CC0 素材做層疊／變調／濾波／殘響，輸出正規化 ogg
import subprocess,numpy as np,os,json,functools
from scipy import signal
import pyloudnorm as pyln
SR=48000
O='/home/claude/audio/sfx/oga/'
@functools.lru_cache(None)
def _load(p):
    r=subprocess.run(['ffmpeg','-v','error','-i',O+p,'-ac','1','-ar',str(SR),'-f','f32le','-'],capture_output=True)
    x=np.frombuffer(r.stdout,dtype=np.float32).astype(np.float64)
    if len(x)==0: raise RuntimeError('empty '+p)
    return x
def lead_trim(x,th=0.03):
    pk=np.max(np.abs(x)); i=np.argmax(np.abs(x)>pk*th); return x[max(0,i-int(0.002*SR)):]
def bq(x,typ,f,q=0.707):
    b,a=signal.butter(2,f/(SR/2),btype=typ); return signal.lfilter(b,a,x)
def L(p,t=0.0,g=0.0,st=0.0,ss=0.0,du=None,hp=None,lp=None,rev=False,fo=0.02,fi=0.0,trim=True,spd=None):
    x=_load(p).copy()
    x=x[int(ss*SR):]
    if trim: x=lead_trim(x)
    if du: x=x[:int(du*SR)]
    if rev: x=x[::-1].copy(); x=lead_trim(x) if trim else x
    r=2**(st/12.0) if spd is None else spd
    if abs(r-1)>1e-3:
        from fractions import Fraction
        fr=Fraction(r).limit_denominator(200)
        x=signal.resample_poly(x,fr.denominator,fr.numerator)
    if hp: x=bq(x,'highpass',hp)
    if lp: x=bq(x,'lowpass',lp)
    x=x/max(1e-9,np.max(np.abs(x)))*10**(g/20)
    n=len(x)
    if fi>0: k=min(n,int(fi*SR)); x[:k]*=np.linspace(0,1,k)
    if fo>0: k=min(n,int(fo*SR)); x[n-k:]*=np.linspace(1,0,k)
    return (t,x,p)
def reverb(x,wet=0.25,dec=0.8,lp=5000,pre=0.015):
    n=int(dec*SR); t=np.arange(n)/SR
    rng=np.random.default_rng(7)
    ir=rng.standard_normal(n)*np.exp(-6.9*t/dec)
    ir=bq(ir,'lowpass',lp); ir=bq(ir,'highpass',180)
    ir=np.concatenate([np.zeros(int(pre*SR)),ir]); ir/=np.sqrt(np.sum(ir**2))
    y=signal.fftconvolve(x,ir)[:len(x)+len(ir)]
    xx=np.concatenate([x,np.zeros(len(y)-len(x))])
    return xx+wet*y*1.0
def limiter(x,ceil=-1.0):
    c=10**(ceil/20); a=np.abs(x); 
    la=int(0.004*SR)
    need=np.maximum(1,a/c)
    # 峰值保持＋平滑釋放
    from scipy.ndimage import maximum_filter1d
    g=1/maximum_filter1d(need,size=2*la+1)
    rel=np.exp(-1/(0.06*SR)); gs=np.empty_like(g); cur=1.0
    for i in range(len(g)):
        cur=g[i] if g[i]<cur else rel*cur+(1-rel)*g[i]; gs[i]=cur
    return np.clip(x*gs,-c,c)
meter=pyln.Meter(SR,block_size=0.2)
def lufs(x):
    y=np.concatenate([x,np.zeros(max(0,int(0.5*SR)-len(x)))])
    v=meter.integrated_loudness(y); return v
def build(layers,rv=None,target=-18.0,maxlen=None,tail_db=-50,hp=60,ceil=-1.0):
    end=max(int(t*SR)+len(x) for t,x,p in layers)
    m=np.zeros(end)
    for t,x,p in layers: i=int(t*SR); m[i:i+len(x)]+=x
    if rv: m=reverb(m,**rv)
    if hp: m=bq(m,'highpass',hp)
    # 頭尾裁乾淨
    pk=np.max(np.abs(m)); idx=np.where(np.abs(m)>pk*10**(tail_db/20))[0]
    s=max(0,idx[0]-int(0.002*SR)); e=min(len(m),idx[-1]+int(0.01*SR))
    m=m[s:e]
    if maxlen and len(m)>maxlen*SR: m=m[:int(maxlen*SR)]
    k=min(len(m),int(0.003*SR)); m[:k]*=np.linspace(0,1,k)
    k=min(len(m)//3,int(0.06*SR)); m[len(m)-k:]*=np.linspace(1,0,k)**2
    # 正規化（K 加權響度）＋限幅
    for _ in range(3):
        l=lufs(m); 
        if not np.isfinite(l): break
        m=m*10**((target-l)/20); m=limiter(m,ceil)
    return m, sorted(set(p for _,_,p in layers))
def save(m,path):
    os.makedirs(os.path.dirname(path),exist_ok=True)
    raw=(m.astype(np.float32)).tobytes()
    subprocess.run(['ffmpeg','-v','error','-y','-f','f32le','-ar',str(SR),'-ac','1','-i','-','-ar','44100','-c:a','libvorbis','-q:a','5',path],input=raw,check=True)
def A(arr,t=0.0,g=0.0,tag='zheng',lp=None,hp=None):
    x=np.asarray(arr,dtype=float).copy()
    if hp: x=bq(x,'highpass',hp)
    if lp: x=bq(x,'lowpass',lp)
    x=x/max(1e-9,np.max(np.abs(x)))*10**(g/20)
    return (t,x,'ORIGINAL:'+tag)
