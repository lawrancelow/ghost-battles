import sys,json,os,subprocess,numpy as np
from scipy import signal
sys.path.insert(0,'/home/claude/sfxwork/v2'); from ana import load,metrics,env
SR=44100; OGA='/home/claude/sfxsrc/oga'
def sos(t,f,o=4): return signal.butter(o,f,btype=t,fs=SR,output='sos')
def hp(x,f,o=2): return signal.sosfiltfilt(sos('highpass',f,o),x)
def lp(x,f,o=4): return signal.sosfiltfilt(sos('lowpass',f,o),x)
def dip(x,a,b,db): g=1-10**(-db/20); return x-g*signal.sosfiltfilt(sos('bandpass',[a,b],2),x)
def onset(x,th=0.3):
    e=env(x); return max(0,int(np.argmax(e>e.max()*th))-int(0.004*SR))
def seg(path,dur,off=0.0,th=0.3):
    x=load(path,off,dur+2); i=onset(x,th); return x[i:i+int(dur*SR)].astype(np.float64)
def tame(x,t0,tau):
    e=env(x); pk=int(np.argmax(e)); s=pk+int(t0*SR)
    if s<len(x): x=x.copy(); x[s:]*=np.exp(-np.arange(len(x)-s)/(tau*SR))
    return x
def pitch(x,semi):
    r=2**(semi/12); n=int(len(x)/r); return np.interp(np.arange(n)*r,np.arange(len(x)),x)
def diffuse(x,wet=0.18,t=0.07,L=0.3,lpf=2200,seed=3):
    rng=np.random.default_rng(seed); n=int(L*SR); ir=rng.standard_normal(n)*np.exp(-np.arange(n)/(t*SR)); ir=lp(ir,lpf); ir/=np.sqrt((ir**2).sum())
    y=signal.fftconvolve(x,ir)[:len(x)+n]; out=np.zeros(len(y)); out[:len(x)]=x; return out+wet*y/ max(np.abs(y).max(),1e-9)*np.abs(x).max()
def mix(*parts):
    n=max(len(p)+int(d*SR) for p,g,d in parts); y=np.zeros(n)
    for p,g,d in parts: s=int(d*SR); y[s:s+len(p)]+=p*10**(g/20)
    return y
def finish(x,maxd):
    x=x[:int(maxd*SR)]
    e=env(x); pk=e.max(); t=np.where(e>pk*0.006)[0]; end=min(len(x),t[-1]+int(0.02*SR)) if len(t) else len(x); x=x[:end]
    fi=int(0.002*SR); fo=min(int(0.05*SR),len(x)//3); x=x.copy(); x[:fi]*=np.linspace(0,1,fi); x[-fo:]*=np.linspace(1,0,fo)**2
    e=env(x); act=e>e.max()*0.1; rms=np.sqrt(np.mean(x[act]**2)); x*=10**(-20/20)/max(rms,1e-9); p=np.abs(x).max()
    if p>10**(-1/20): x*=10**(-1/20)/p
    return x.astype(np.float32)
def enc(x,out):
    for ext,a in [('.ogg',['-c:a','libvorbis','-q:a','5']),('.mp3',['-c:a','libmp3lame','-q:a','3'])]:
        subprocess.run(['ffmpeg','-v','error','-y','-f','f32le','-ar',str(SR),'-ac','1','-i','-']+a+[out+ext],input=x.tobytes(),check=True)
P=lambda s:os.path.join(OGA,s)
MW='100-cc0-metal-and-wood-sfx/x/'
def wood(name,dur=0.35): x=seg(P(MW+name),dur); return x
def synth_chop(seed=1):
    rng=np.random.default_rng(seed); n=int(0.32*SR); t=np.arange(n)/SR
    body=sum(a*signal.sosfiltfilt(sos('bandpass',[f*0.75,f*1.33],1),rng.standard_normal(n))*np.exp(-t/d) for f,a,d in [(280,1.0,0.03),(420,0.9,0.025),(640,0.7,0.018),(950,0.45,0.012)])
    body+= signal.sosfiltfilt(sos('bandpass',[250,2200],2),rng.standard_normal(n))*np.exp(-t/0.01)*1.4
    body=lp(body,2400)
    crack=hp(rng.standard_normal(n)*np.exp(-t/0.008),2500); crack=lp(crack,7000)
    # fiber crackle grains
    gr=np.zeros(n)
    for k in range(9):
        p=int((0.004+rng.uniform(0,0.05))*SR); L=int(0.0025*SR); gr[p:p+L]+=rng.standard_normal(L)*rng.uniform(0.2,0.6)*np.hanning(L)
    gr=lp(hp(gr,1500),6000)
    return 2.2*body+0.2*crack+0.3*gr
def synth_reap(seed=2):
    rng=np.random.default_rng(seed); n=int(0.42*SR); t=np.arange(n)/SR
    sw=rng.standard_normal(n); envs=np.clip(t/0.025,0,1)*np.exp(-np.clip(t-0.025,0,None)/0.05)
    sw=signal.sosfiltfilt(sos('bandpass',[700,4500],2),sw)*envs
    gr=np.zeros(n)
    for k in range(26):
        p=int(rng.uniform(0.02,0.22)*SR); L=int(rng.uniform(0.0015,0.004)*SR); gr[p:p+L]+=rng.standard_normal(L)*rng.uniform(0.15,0.7)*np.hanning(L)
    gr=lp(hp(gr,1200),6500)
    return sw+0.7*gr

def synth_knead(seed=4):
    rng=np.random.default_rng(seed); n=int(0.3*SR); t=np.arange(n)/SR
    a=np.clip(t/0.005,0,1)*np.exp(-np.clip(t-0.005,0,None)/0.035)
    slap=signal.sosfiltfilt(sos('bandpass',[220,1400],1),rng.standard_normal(n))*a
    # squelch: low formant gliding down (puff of air out of dough), noise-based
    f0=np.linspace(700,260,n); ph=np.cumsum(f0)/SR
    puff=signal.sosfiltfilt(sos('bandpass',[250,900],1),rng.standard_normal(n))*np.exp(-np.clip(t-0.012,0,None)/0.05)*np.clip((t-0.008)/0.01,0,1)*0.6
    flour=np.zeros(n)
    for k in range(40):
        p=int(rng.uniform(0.03,0.25)*SR); L=int(0.0012*SR); flour[p:p+L]+=rng.standard_normal(L)*rng.uniform(0.004,0.015)
    flour=lp(hp(flour,3000),7000)
    return lp(slap+puff,2200)+flour
