import random, statistics
random.seed(7)
PRI=[3,4,5,6]; FRESH=[1,1,.5,.25]; RESP=[5,10,20,40]
SUMMON={'凡':30,'靈':60,'煞':90,'王':120}
RANK={'凡':110,'靈':145,'煞':175,'王':220}
GOOD=0.7   # 假設七成場次打得好（+1）
def cur(ring,minutes):            # 現行：每場必掉；當日同一據點第 3 場起打折
    r=ring-1; t=0; n=0; s=0
    while t<=minutes:
        mul=FRESH[min(n,3)]
        base=PRI[r]+(1 if random.random()<.3 else 0)
        s+=max(1,round(base*mul))+(1 if random.random()<GOOD else 0)
        n+=1; t+=RESP[r]
    return s,n
# 新：名鬼按品級冷卻；每場保底 g，另有 p 機率大爆 +j；連續 pity-1 場沒爆則必爆；不再有當日打折
NEW={'凡':dict(cd=10,g=3,p=.30,j=2,pity=4),'靈':dict(cd=30,g=5,p=.30,j=4,pity=4),'煞':dict(cd=60,g=6,p=.35,j=6,pity=3),'王':dict(cd=180,g=12,p=.40,j=12,pity=3)}
def new(pin,minutes):
    d=NEW[pin]; t=0; n=0; s=0; miss=0
    while t<=minutes:
        hit=random.random()<d['p'] or miss+1>=d['pity']
        s+=d['g']+(d['j'] if hit else 0)+(1 if random.random()<GOOD else 0)
        miss=0 if hit else miss+1
        n+=1; t+=d['cd']
    return s,n
def avg(f,*a,N=4000):
    xs=[f(*a) for _ in range(N)]; return statistics.mean(x[0] for x in xs), xs[0][1]
TYP={'凡':[1,2],'靈':[2,3],'煞':[3,4],'王':[3]}   # 該品級駐守鬼常見的圈
print('品級 | 時段 | 現行(各圈) | 新 | 新場數')
for pin in '凡靈煞王':
    for nm,mins in [('1小時',60),('一天玩3小時',180),('一天掛16小時',960)]:
        c=' / '.join('第%d圈 %.0f'%(r,avg(cur,r,mins)[0]) for r in TYP[pin])
        a,n=avg(new,pin,mins)
        print(pin,nm,'|',c,'|','%.0f'%a,'|',n)
    a3=avg(new,pin,180)[0]; a16=avg(new,pin,960)[0]
    tot=SUMMON[pin]+RANK[pin]
    print('   招降要',SUMMON[pin],'升滿共',tot,'| 每天3小時：招降 %.1f 天、升滿 %.1f 天 | 每天16小時：招降 %.1f 天、升滿 %.1f 天'%(SUMMON[pin]/a3,tot/a3,SUMMON[pin]/a16,tot/a16))
