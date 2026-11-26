# 本組原創：Karplus-Strong 撥弦（古箏味），用遊戲背景音樂同一音階 D F G A C（snd_impl SCALE）
import numpy as np
from scipy import signal
SR=48000
SC=[146.83,174.61,196.0,220.0,261.63,293.66,349.23,392.0,440.0,523.25,587.33,698.46,783.99,880.0]
def pluck(f,dur=1.6,bright=0.6,bend=0.0,harm=False,seed=1):
    rng=np.random.default_rng(seed)
    N=int(SR/f); n=int(dur*SR)
    ex=rng.uniform(-1,1,N)
    # 撥弦位置（梳狀濾波）＋指甲亮度
    p=max(1,int(N*0.13)); ex=ex-np.roll(ex,p)
    ex=signal.lfilter([bright,1-bright],[1],ex)
    y=np.zeros(n); buf=ex.copy(); L=N; i=0
    # 分數延遲＋按弦滑音（bend：半音數，喺頭 0.25 秒後慢慢推上去）
    out=np.zeros(n); line=np.zeros(N*2+4); line[:N]=ex
    d=np.zeros(n)
    t=np.arange(n)/SR
    fr=f*2**((bend*np.clip((t-0.18)/0.35,0,1))/12)
    period=SR/fr
    hist=np.zeros(n+N*3); hist[:N]=ex[::-1]*0  # 用歷史陣列實作
    hist=np.concatenate([ex,np.zeros(n)])
    loss=0.996 if f<300 else 0.994
    for k in range(N,N+n):
        P=period[k-N]; j=k-P; j0=int(j); a=j-j0
        s=(1-a)*hist[j0]+a*hist[j0+1]; s2=(1-a)*hist[j0-1]+a*hist[j0]
        hist[k]=loss*0.5*(s+s2)
    y=hist[N:N+n]
    if harm:   # 泛音：抽走基音，留高八度，純淨啲
        y=y-np.roll(y,int(SR/f/2)); 
    env=np.exp(-t*1.2)
    y=y*env
    # 琴身共鳴（兩個帶通）
    b1,a1=signal.butter(2,[180/(SR/2),420/(SR/2)],'band'); b2,a2=signal.butter(2,[900/(SR/2),2600/(SR/2)],'band')
    y=y+0.35*signal.lfilter(b1,a1,y)+0.25*signal.lfilter(b2,a2,y)
    return y/np.max(np.abs(y))
def seq(notes,gap=0.07,dur=1.6,**kw):
    n=int((gap*len(notes)+dur)*SR); y=np.zeros(n)
    for i,(idx,g) in enumerate(notes):
        x=pluck(SC[idx],dur=dur,seed=idx+3,**kw)*10**(g/20); s=int(i*gap*SR); y[s:s+len(x)]+=x
    return y
