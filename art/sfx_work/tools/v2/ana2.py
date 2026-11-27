import sys,numpy as np
from scipy.ndimage import median_filter
sys.path.insert(0,'/home/claude/sfxwork/v2'); from ana import load,env,SR
def m2(x):
    x=np.asarray(x,np.float64); e=env(x); pk=int(np.argmax(e)); hp_=e[pk]
    N=16384; f=np.fft.rfftfreq(N,1/SR)
    def spec(s):
        if len(s)<512: s=np.pad(s,(0,512-len(s)))
        return np.abs(np.fft.rfft(s*np.hanning(len(s)),n=N))**2
    S=spec(x); tot=S.sum()+1e-20
    band=lambda S,a,b: S[(f>=a)&(f<b)].sum()
    t=x[pk+int(0.06*SR):pk+int(0.35*SR)]
    tail_ratio=float((t**2).sum()/((x**2).sum()+1e-20))
    T=spec(t) if len(t)>256 else np.zeros_like(S); Tt=T.sum()+1e-20
    m=(f>=300)&(f<9000)
    base=median_filter(T,size=81)  # ~216Hz window
    peaks=(T>8*base)&m
    ring=float(T[peaks].sum()/Tt)*tail_ratio**0.5 if Tt>1e-12 else 0.0
    after=np.where(e[pk:]<hp_*10**(-30/20))[0]; dec=(after[0]/SR) if len(after) else (len(x)-pk)/SR
    e2=env(x,88); p2=int(np.argmax(e2)); st=np.where(e2[:p2+1]<e2[p2]*0.1)[0]; att=(p2-(st[-1] if len(st) else 0))/SR
    out=dict(att_ms=round(att*1000,1),dur=round(len(x)/SR,3),dec30=round(dec,3),cent=int((S*f).sum()/tot),
      b_lo=round(band(S,0,300)/tot,3),b_mid=round(band(S,300,1500)/tot,3),b_metal=round(band(S,1500,6000)/tot,3),b_air=round(band(S,6000,22050)/tot,3),
      tail=round(tail_ratio,3),ring=round(ring,4))
    return out
def verdict(o,ev):
    v=[]
    if o['ring']>0.015: v.append('金屬殘響')
    if ev=='wk_knead_roll':
        if o['b_metal']>0.25: v.append('太硬／太尖')
        if o['b_lo']>0.6: v.append('太低沉（手機喇叭聽不清）')
        if o['dec30']>0.2: v.append('尾音太長')
        if o['att_ms']<1.5: v.append('起音太硬（像硬物撞擊）')
    elif ev=='wk_chop_hit':
        if o['b_lo']>0.65: v.append('太低沉（手機喇叭聽不清）')
        if o['b_metal']>0.3: v.append('2–6kHz 太多')
        if o['dec30']>0.2: v.append('尾音太長')
    else:
        if o['b_air']>0.35: v.append('太嘶')
        if o['b_lo']>0.45: v.append('太低沉（手機喇叭聽不清）')
        if o['dec30']>0.3: v.append('尾音太長')
    return '、'.join(v) or 'OK'
if __name__=='__main__':
    for p in sys.argv[1:]: o=m2(load(p)); ev='wk_chop_hit' if 'chop' in p else ('wk_knead_roll' if 'knead' in p else 'wk_reap_cut'); print(p.split('/')[-1], verdict(o,ev), o)
