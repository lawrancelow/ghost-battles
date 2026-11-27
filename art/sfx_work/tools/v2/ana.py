import sys,subprocess,numpy as np
SR=44100
def load(p,off=0.0,dur=4.0):
    r=subprocess.run(['ffmpeg','-v','error','-ss',str(off),'-t',str(dur),'-i',p,'-ac','1','-ar',str(SR),'-f','f32le','-'],capture_output=True)
    return np.frombuffer(r.stdout,np.float32).copy()
def env(x,w=441): return np.sqrt(np.convolve(x**2,np.ones(w)/w,'same'))
def metrics(x):
    if len(x)<1000: return None
    e=env(x); pk=int(np.argmax(e)); hp=e[pk]
    on=int(np.argmax(e>hp*0.3))
    # decay to -30dB after peak
    after=np.where(e[pk:]<hp*10**(-30/20))[0]; dec=(after[0]/SR) if len(after) else (len(x)-pk)/SR
    seg=x[on:on+int(0.2*SR)]
    if len(seg)<4096: seg=np.pad(seg,(0,4096-len(seg)))
    w=seg*np.hanning(len(seg)); S=np.abs(np.fft.rfft(w,n=16384))**2; f=np.fft.rfftfreq(16384,1/SR)
    tot=S.sum()+1e-12
    b=lambda a,c:S[(f>=a)&(f<c)].sum()/tot
    bands=dict(lo=b(0,250),lm=b(250,1000),mid=b(1000,2000),hi=b(2000,6000),air=b(6000,22050))
    # tonality 1.5-8k: peak vs median (smoothed) in dB
    m=(f>=1500)&(f<8000); Sm=S[m]
    ton=10*np.log10((Sm.max()+1e-12)/(np.median(Sm)+1e-12))
    # tail tonality: spectral flatness of tail 80-300ms after peak in 1.5-8k (metal rings => low flatness)
    t=x[pk+int(0.08*SR):pk+int(0.3*SR)]
    if len(t)>2048 and np.abs(t).max()>hp*0.02:
        T=np.abs(np.fft.rfft(t*np.hanning(len(t)),n=16384))**2; Tm=T[m]+1e-12
        flat=np.exp(np.mean(np.log(Tm)))/np.mean(Tm)
    else: flat=1.0
    cent=(S*f).sum()/tot
    return dict(dec=round(dec,3),cent=int(cent),ton=round(ton,1),tflat=round(float(flat),3),**{k:round(v,3) for k,v in bands.items()})
def metal_score(m):
    # higher = more metallic
    s=0.0
    s+=max(0,m['ton']-18)*0.5           # tonal peaks in 1.5-8k
    s+=max(0,m['dec']-0.18)*20          # long ring
    s+=max(0,0.15-m['tflat'])*40 if m['tflat']<1 else 0  # tonal tail
    s+=max(0,m['hi']-0.25)*20           # 2-6k energy
    return round(s,2)
if __name__=='__main__':
    for p in sys.argv[1:]:
        x=load(p); m=metrics(x)
        if m: print(round(len(x)/SR,2), metal_score(m), m, p.split('/oga/')[-1])
