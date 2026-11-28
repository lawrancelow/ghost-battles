import sys
from PIL import Image, ImageDraw, ImageFont
out=sys.argv[1]
FD='/usr/share/fonts/opentype/noto/'
def F(sz,bold=False):
    for n in (['NotoSansCJK-Bold.ttc','NotoSansCJK-Black.ttc'] if bold else ['NotoSansCJK-Regular.ttc','NotoSansCJK-Medium.ttc','NotoSansCJK-Bold.ttc']):
        try: return ImageFont.truetype(FD+n,sz,index=3)   # TC
        except Exception: pass
    return ImageFont.truetype(FD+'NotoSerifCJK-Bold.ttc',sz,index=3)
W=1800; PAD=48
BG='#1b1620'; CARD='#251e2b'; INK='#efe6f2'; MUTE='#b4a6bb'; RED='#e0584e'; GOLD='#ffd27a'; LINE='#3a2f42'; OK='#6fcf97'
cols=['','A 出差單','B 嚇到他辭職（推薦）','C 地盤掛機']
rows=[
 ['一句話','每次出擊是冥界老闆發的出差申請單，有指定目標和報銷額度','敵人多一條膽量條：打光血＝打散拿材料；嚇光膽＝辭職變自己人','打下的據點變收數點，派鬼駐守自動產出，幫派定時反撲'],
 ['玩家每分鐘\n在做什麼','看單、選誰去、自動打、回來報銷','戰前排 3 招嚇法；戰中抓失神窗口接連嚇；決定打散還是嚇走','分配駐守、收錢、偶爾擊退反撲'],
 ['戰鬥時長','6–20 秒（不變）','40–70 秒，有決定可做','幾乎不看戰鬥'],
 ['餵村子','出差單指定掉卡點材料','打散掉棺材板；辭職雜鬼進酒館','穩定掉材料'],
 ['餵 KPI','完成 N 張出差單','嚇到 N 隻辭職、清剿某幫','累計擊退反撲 N 次'],
 ['餵市集','帶回該章獨有貨源','辭職名鬼變熟客；清掉幫派，市集治安事件變少','穩定掉貨源'],
 ['每章不同玩法','沒有','有：餓、偷、屍變、潮、怪談規則、審批','沒有'],
 ['工作量','中','中–大（第一批 1 天）','小–中'],
 ['最大風險','變成另一張任務清單','平衡要重調；要保留自動開關','沒有新樂趣'],
]
cw=[230,470,560,444]
ft=F(30); fb=F(30,True); fh=F(34,True); ftitle=F(54,True); fsub=F(30)
def wrap(d,txt,font,w):
    lines=[]
    for para in txt.split('\n'):
        cur=''
        for ch in para:
            if d.textlength(cur+ch,font=font)>w: lines.append(cur); cur=ch
            else: cur+=ch
        lines.append(cur)
    return lines
tmp=Image.new('RGB',(10,10)); d=ImageDraw.Draw(tmp)
LH=42
def rh(r):
    return max(len(wrap(d,c,fb if i in(0,2) else ft,cw[i]-36)) for i,c in enumerate(r))*LH+30
heights=[rh(r) for r in rows]
qs=['1. 方向選哪個？建議：B，外面包出差單，掃蕩之後再做',
    '2. 戰鬥要不要手動點嚇法牌？建議：要，但保留「自動」開關，手動約多 20% 收益',
    '3. 魂魄權重表用哪版？建議：上表（沒有空手，最低檔很少）；另一版有 10–12% 空手加保底']
qh=[len(wrap(d,q,ft,W-2*PAD-40))*LH for q in qs]
H=PAD+70+50+30+70+sum(heights)+40+50+sum(qh)+20*len(qs)+PAD+44+58+5*LH+14+60+4*58
im=Image.new('RGB',(W,H),BG); d=ImageDraw.Draw(im)
y=PAD
d.text((PAD,y),'野外打怪：三個方向對照',font=ftitle,fill=INK); y+=78
d.text((PAD,y),'現況：內容很厚（96 據點、13 種敵人機制、8×8 嚇法克制），但戰鬥只有 6–20 秒全自動，和村子、KPI、市集沒關係',font=F(26),fill=MUTE); y+=60
x=PAD
for i,c in enumerate(cols):
    d.rectangle([x,y,x+cw[i],y+66],fill=('#5a231f' if i==2 else '#33293b'),outline=LINE)
    d.text((x+18,y+12),c,font=fh,fill=(GOLD if i==2 else INK)); x+=cw[i]
y+=66
for r,h in zip(rows,heights):
    x=PAD
    for i,c in enumerate(r):
        d.rectangle([x,y,x+cw[i],y+h],fill=('#2f2029' if i==2 else CARD),outline=LINE)
        f=fb if i in(0,2) else ft
        col=MUTE if i==0 else (INK)
        yy=y+15
        for ln in wrap(d,c,f,cw[i]-36):
            d.text((x+18,yy),ln,font=f,fill=col); yy+=LH
        x+=cw[i]
    y+=h

y+=44
d.text((PAD,y),'名鬼據點冷卻重生（不設永久佔領，可以一直刷）',font=fh,fill=GOLD); y+=58
for ln in ['據點雜兵照舊 5–40 分鐘重生，資源照掉；駐守名鬼和野外王按品級「請假」，銷假後重生再刷魂魄。','第一場必掉；之後每場抽數量，有多有少，沒有空手。產出每個時段都不比現在少；取消每日打折。','解霧、拔營只看首勝和首殺，重生不會卡關。升滿後多的魂魄換散魂，可到「魂魄報銷處」換市集貨和酒館招募。']:
    for l2 in wrap(d,ln,ft,W-2*PAD-20):
        d.text((PAD+10,y),l2,font=ft,fill=INK); y+=LH
y+=14
c2=['品級','冷卻','首殺必掉','之後每場：很少／普通／不錯／大爆','升滿（每天 1 小時）']
w2=[120,160,180,890,354]
r2=[['凡','10 分鐘','10 個','1 個 30%｜3 個 37%｜6 個 23%｜12 個 10%','57 天'],['靈','30 分鐘','12 個','1 個 28%｜5 個 37%｜10 個 25%｜20 個 10%','86 天'],['煞','1 小時','15 個','2 個 28%｜7 個 37%｜14 個 25%｜28 個 10%','89 天'],['王','3 小時','20 個','4 個 28%｜14 個 37%｜28 個 25%｜55 個 10%','71 天']]
x=PAD
for i,c in enumerate(c2):
    d.rectangle([x,y,x+w2[i],y+60],fill='#33293b',outline=LINE); d.text((x+14,y+10),c,font=F(28,True),fill=INK); x+=w2[i]
y+=60
for r in r2:
    x=PAD
    for i,c in enumerate(r):
        d.rectangle([x,y,x+w2[i],y+58],fill=CARD,outline=LINE); d.text((x+14,y+9),c,font=(fb if i==0 else ft),fill=INK); x+=w2[i]
    y+=58
y+=40
d.text((PAD,y),'要你拍板',font=fh,fill=RED); y+=54
for q in qs:
    for ln in wrap(d,q,ft,W-2*PAD-40):
        d.text((PAD+10,y),ln,font=ft,fill=INK); y+=LH
    y+=20
im.save(out,quality=92); print(im.size)
