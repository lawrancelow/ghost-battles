# 駐點（普通據點佔領）產出 vs 親自刷：第 1 章估算。只用代碼常數算，不跑遊戲。
# 假設都寫在這裡，改參數重跑即可：python3 post_sim.py
REW_COIN=30; REPLAY_COIN=20            # so_data.gd REW_COIN＋Battle.finish「再打」獎（冥幣 × 等級）
PLANK=[4,8,14,20]; RESP=[5,10,20,40]   # so_data.gd REW_PLANK、RESPAWN_MIN
LV=[1.3,2.3,3.8,5.3]                   # 第 1 章各圈平均難度等級（LV_BASE[0]=1＋LV_RING＋圈內次序）
POST=[3,3,3,0]; NAMED=[1,1,1,4]        # 參數：每圈普通據點／名鬼據點數（每章 9＋7）
POST_WINS_H=3.0                        # 參數：駐點每小時產出＝該據點打贏 3 場的獎勵（老闆定案）
TILL_H=2; OFF_H=8                      # 參數：沒有名鬼主任時收銀箱只存 2 小時；有名鬼主任自動入帳，離線最多算 8 小時
CYCLE_S=90; PAR=2                      # 假設：一場出擊（行軍＋打＋回村）90 秒，同時 2 場
BOOST=1.5; BOOST_MIN=30                # 參數：親自擊退反撲，該駐點 30 分鐘產出 ×1.5
RAID_H=6; FAIL_STORE=0.30; DOWN_MIN=10 # 參數：線上每 10 分鐘一次反撲；沒守住：該點存貨丟 30%、停業到玩家收復（假設 10 分鐘）
def win(r): return (REW_COIN+REPLAY_COIN)*LV[r], PLANK[r]
def post_h(staffed=1.0):
    c=sum(POST[r]*POST_WINS_H*win(r)[0] for r in range(4))*staffed
    p=sum(POST[r]*POST_WINS_H*win(r)[1] for r in range(4))*staffed
    return c,p
def active_h(cnt):
    fights=[cnt[r]*60/RESP[r] for r in range(4)]; cap=3600/CYCLE_S*PAR
    k=min(1,cap/sum(fights))
    return sum(fights[r]*k*win(r)[0] for r in range(4)), sum(fights[r]*k*win(r)[1] for r in range(4)), sum(fights)*k
old=active_h([4,4,4,4]); new=active_h(NAMED); ph=post_h()
print('現在：16 個據點全部親自刷（理論上限，每小時 %.0f 場）：冥幣 %.0f、棺材板 %.0f'%(old[2],old[0],old[1]))
print('新：親自刷 7 個名鬼據點（每小時 %.0f 場）：冥幣 %.0f、棺材板 %.0f'%(new[2],new[0],new[1]))
print('新：9 個駐點全部有人（每小時）：冥幣 %.0f、棺材板 %.0f'%ph)
tot=new[0]+ph[0]
print('A 又打又駐點：冥幣 %.0f／小時（駐點佔 %.0f%%）'%(tot,ph[0]/tot*100))
print('B 只打不駐點：%.0f／小時＝A 的 %.0f%%'%(new[0],new[0]/tot*100))
print('C 只駐點不打（線上掛著）：%.0f／小時＝A 的 %.0f%%'%(ph[0],ph[0]/tot*100))
for staffed in (3,5,9):
    c=post_h(staffed/9)[0]; print('  只派 %d 隻去駐點：駐點 %.0f／小時，合計＝A 的 %.0f%%'%(staffed,c,(new[0]+c)/tot*100))
# 反撲
per_post_h=ph[0]/9
loss_fail=per_post_h*TILL_H*FAIL_STORE+per_post_h*DOWN_MIN/60
print('反撲：每小時 %d 次。每次沒守住的損失約 %.0f 冥幣（存貨 30%%＋停業 %d 分鐘）'%(RAID_H,loss_fail,DOWN_MIN))
for fail in (0.0,0.25,0.5,1.0):
    print('  沒守住比例 %.0f%% → 每小時損失 %.0f（佔駐點產出 %.0f%%）'%(fail*100,RAID_H*fail*loss_fail,RAID_H*fail*loss_fail/ph[0]*100))
bonus=per_post_h*(BOOST-1)*BOOST_MIN/60
print('親自擊退一次的額外產出：%.0f 冥幣（另掉領隊名鬼魂魄）；每小時 6 次全親自守＝多 %.0f（駐點產出 +%.0f%%）'%(bonus,6*bonus,6*bonus/ph[0]*100))
# 離線 8 小時
print('離線 8 小時：有名鬼主任 %.0f；沒有主任（收銀箱 2 小時滿）%.0f；最多發生 1 次反撲，最壞損失 %.0f'%(ph[0]*OFF_H,ph[0]*TILL_H,loss_fail))
print('對照：同樣 8 小時線上親自打 %.0f'%(new[0]*8))
