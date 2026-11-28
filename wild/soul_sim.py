# 野外名鬼據點魂魄產出模擬（用代碼現行公式 vs 新權重表）。不跑遊戲，只算數。
# 用法：python3 soul_sim.py
import random, statistics
random.seed(11)
PRI=[3,4,5,6]; FRESH=[1,1,.5,.25]; RESP=[5,10,20,40]   # 現行：soul_data.gd PRI／FRESH、so_data.gd RESPAWN_MIN
GOOD=0.7                                                 # 假設七成場次「打得好」（+1）
SUMMON={'凡':30,'靈':60,'煞':90,'王':120}                # soul_data.gd SUMMON
RANK={'凡':110,'靈':145,'煞':175,'王':220}               # RANK_COST 五級合計
BORN={'凡':0,'靈':3,'煞':6,'王':9}                       # soul_up.gd born()
FUSE=lambda to: round(8*1.45**to)                        # soul_up.gd fuse_cost().own
STAR=235                                                 # STAR_SOUL 20+30+45+60+80（升到鬼王品後上限 5 星）
def total(pin): return SUMMON[pin]+RANK[pin]+sum(FUSE(t) for t in range(BORN[pin]+1,12))+STAR
CD={'凡':10,'靈':30,'煞':60,'王':180}                    # 新：名鬼冷卻（分鐘）
FIRST={'凡':10,'靈':12,'煞':15,'王':20}                  # 新：首殺必掉
# 新權重表：[(數量, 權重%)]
A={'凡':[(0,12),(1,20),(3,35),(6,23),(12,10)],'靈':[(0,12),(2,20),(5,35),(10,23),(20,10)],
   '煞':[(0,12),(3,20),(7,35),(14,23),(28,10)],'王':[(0,10),(6,20),(14,35),(28,25),(55,10)]}
B={'凡':[(1,30),(3,37),(6,23),(12,10)],'靈':[(1,28),(5,37),(10,25),(20,10)],
   '煞':[(2,28),(7,37),(14,25),(28,10)],'王':[(4,28),(14,37),(28,25),(55,10)]}
PITY_A=2   # 版本 A：連續 2 場沒掉，第 3 場改抽「不含沒掉」的表
def roll(tb): 
    x=random.uniform(0,sum(w for _,w in tb))
    for n,w in tb:
        x-=w
        if x<=0: return n
    return tb[-1][0]
def cur(ring,minutes):
    r=ring-1; t=0; n=0; s=0
    while t<=minutes:
        base=PRI[r]+(1 if random.random()<.3 else 0)
        s+=max(1,round(base*FRESH[min(n,3)]))+(1 if random.random()<GOOD else 0); n+=1; t+=RESP[r]
    return s
def new(ver,pin,minutes,state=None):
    tb=(A if ver=='A' else B)[pin]; t=0; s=0; st=state if state is not None else {'miss':0}
    while t<=minutes:
        if ver=='A' and st['miss']>=PITY_A: n=roll([x for x in tb if x[0]>0])
        else: n=roll(tb)
        st['miss']=st['miss']+1 if n==0 else 0
        s+=n+(1 if (n>0 and random.random()<GOOD) else 0); t+=CD[pin]
    return s
def mean(f,*a,N=6000): return statistics.mean(f(*a) for _ in range(N))
def ev(tb): return sum(n*w for n,w in tb)/sum(w for _,w in tb)
TYP={'凡':[1,2],'靈':[2,3],'煞':[3,4],'王':[3]}
print('== 每場期望（不含打得好）')
for p in '凡靈煞王': print(p,'A %.2f'%ev(A[p]),'B %.2f'%ev(B[p]),' 升滿總消耗',total(p),'（招降＋職級',SUMMON[p]+RANK[p],'）')
print('== 產出（單一名鬼主魂；現在取常見圈較高者 → A → B）')
res={}
for p in '凡靈煞王':
    for nm,m in [('1小時',60),('3小時',180),('16小時',960)]:
        c=max(mean(cur,r,m) for r in TYP[p]); a=mean(new,'A',p,m); b=mean(new,'B',p,m); res[(p,nm)]=(c,a,b)
        print(p,nm,'現在 %.0f → A %.0f → B %.0f'%(c,a,b))
print('== 升滿天數（B；每天 1 小時／3 小時；冷卻離線照算，所以每次上線名鬼都在）')
for p in '凡靈煞王':
    d1=res[(p,'1小時')][2]; d3=res[(p,'3小時')][2]
    print(p,'招降＋職級滿：%.0f 天／%.0f 天'%((SUMMON[p]+RANK[p])/d1,(SUMMON[p]+RANK[p])/d3),'｜全部升滿：%.0f 天／%.0f 天'%(total(p)/d1,total(p)/d3))
print('== 手感：王（每天 1 小時＝每天打 1 場），連續 30 天')
for ver in 'AB':
    zero=[];low=[]
    for _ in range(4000):
        st={'miss':0}; xs=[new(ver,'王',0,st) for _ in range(30)]
        zero.append(sum(1 for x in xs if x==0)); low.append(min(xs))
    print(ver,'30 天裡空手而回的天數 平均 %.1f、最多 %d'%(statistics.mean(zero),max(zero)))
