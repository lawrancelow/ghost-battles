import sys
from PIL import Image, ImageDraw, ImageFont
out=sys.argv[1]; FD='/usr/share/fonts/opentype/noto/'
def F(sz,bold=False): return ImageFont.truetype(FD+('NotoSansCJK-Bold.ttc' if bold else 'NotoSansCJK-Regular.ttc'),sz,index=3)
W=1800; PAD=48; BG='#1b1620'; CARD='#251e2b'; INK='#efe6f2'; MUTE='#b4a6bb'; RED='#e0584e'; GOLD='#ffd27a'; LINE='#3a2f42'
ft=F(31); fb=F(31,True); fh=F(36,True); LH=44
tmp=Image.new('RGB',(10,10)); dd=ImageDraw.Draw(tmp)
def wrap(txt,font,w):
    L=[]
    for para in txt.split('\n'):
        cur=''
        for ch in para:
            if dd.textlength(cur+ch,font=font)>w: L.append(cur); cur=ch
            else: cur+=ch
        L.append(cur)
    return L
ops=[]  # (kind, ...)
def table(cols,cw,rows,hl=None):
    ops.append(('th',cols,cw,hl))
    for r in rows: ops.append(('tr',r,cw,hl))
def title(t,col=GOLD): ops.append(('h',t,col))
def para(t,col=INK): ops.append(('p',t,col))
def gap(n): ops.append(('g',n))
ops.append(('title','野外打怪　定案版：外派駐點＋名鬼據點可刷'))
ops.append(('sub','每章 16 個據點分兩種。同一隻鬼同時只能做一件事：村子幹活、市集顧攤、市集巡邏、出擊、外派駐點，五選一。'))
table(['','普通據點（每章 9 個）','名鬼據點＋野外王（每章 7＋4 個）'],[250,727,727],[
 ['打贏之後','佔領，變成「駐點辦事處」','不能佔領；名鬼按品級「請假」，銷假後重生'],
 ['玩家做什麼','派鬼外派當主任 → 自動產資源 → 收錢 → 幫派反撲時去守','一直回去打，刷魂魄'],
 ['產出','冥幣、棺材板、該章市集獨有貨源','魂魄：第一場必掉，之後每場抽數量，有多有少'],
 ['節奏','線上約每 10 分鐘一次反撲；離線產出最多算 8 小時，最多 1 次反撲','冷卻：凡 10 分鐘、靈 30 分鐘、煞 1 小時、王 3 小時'],
 ['沒顧好會怎樣','該駐點停業整頓、收銀箱丟三成、主任回村，要再打一次收復','沒有損失，等銷假再來'],
 ['不會發生的事','不連鎖、不卡關：解霧、拔營、KPI 都只看永久記錄','同左'],
])
gap(36); title('和村子、KPI、市集的關係')
table(['餵誰','怎麼餵'],[250,1454],[
 ['村子重建','駐點產棺材板（前期最大卡點）；親自擊退反撲有機會俘虜雜鬼進酒館'],
 ['KPI 考核','只算累計：累計開張幾個駐點、累計擊退幾次反撲。駐點被搶不會讓考核倒退'],
 ['過勞鬼市集','每個幫派地盤產該章獨有貨源；外派和巡邏（每街 0–4 隻）、店員搶同一批鬼'],
])
gap(36); title('每章反撲都不一樣')
para('① 討飯：錢存越多來越勤，可派包子打發　② 偷：隱身偷收銀箱，主任要會「燈」　③ 加班回魂：被擊退會再來第二波')
para('④ 潮汐：漲潮停產、退潮加倍但反撲集中　⑤ 挖角：駐太久會被挖走，要輪調　⑥ 稽核：查帳的官，交公文或賄賂')
gap(36); title('收益估算（第 1 章，用代碼數字算，未實測）')
table(['玩法','冥幣／小時','相對比例'],[900,400,404],[
 ['又打又駐點（9 個駐點滿員）','5850','100%'],
 ['只打，不派人駐點','3630','62%'],
 ['只駐點，完全不打','2220','38%'],
])
para('掛機不會取代親自打，不掛機也不會落後太多；魂魄只有親自打和親自守才有。',MUTE)
gap(36); title('第一批（1 天，只做第 1 章）')
para('1. 據點分兩種　2. 佔領、派主任、產出、收銀箱、離線結算　3. 反撲與停業整頓、收復　4. 第 1 章「討飯」')
para('5. 名鬼冷卻、首殺必掉、權重表、取消每日打折　6. 舊存檔遷移　7. 測試：進度不倒退、顯示＝實際。不需要新畫圖。')
gap(36); title('要你拍板',RED)
for q in ['1. 每章怎麼分？建議：9 個普通＋7 個名鬼（每圈最強 1 個＋第 4 圈全部）；普通據點原本的名鬼改當反撲領隊',
          '2. 現有「兵營清剿」（陰兵掛機產冥幣）併進駐點嗎？建議：併，避免三套掛機並存；第二批做',
          '3. 沒守住的後果照上表嗎？建議：照做；嫌重可改成停業 10 分鐘後自動復工']:
    para(q)
def row_h(r,cw,bold0=True):
    return max(len(wrap(c,fb if i==0 else ft,cw[i]-36)) for i,c in enumerate(r))*LH+28
def measure():
    y=PAD
    for o in ops:
        k=o[0]
        if k=='title': y+=84
        elif k=='sub': y+=len(wrap(o[1],F(27),W-2*PAD))*38+22
        elif k=='th': y+=66
        elif k=='tr': y+=row_h(o[1],o[2])
        elif k=='h': y+=58
        elif k=='p': y+=len(wrap(o[1],ft,W-2*PAD-20))*LH+8
        elif k=='g': y+=o[1]
    return y+PAD
H=measure(); im=Image.new('RGB',(W,H),BG); d=ImageDraw.Draw(im); y=PAD
for o in ops:
    k=o[0]
    if k=='title': d.text((PAD,y),o[1],font=F(54,True),fill=INK); y+=84
    elif k=='sub':
        for ln in wrap(o[1],F(27),W-2*PAD): d.text((PAD,y),ln,font=F(27),fill=MUTE); y+=38
        y+=22
    elif k=='th':
        x=PAD
        for i,c in enumerate(o[1]):
            d.rectangle([x,y,x+o[2][i],y+66],fill='#33293b',outline=LINE); d.text((x+18,y+11),c,font=fh,fill=GOLD if i>0 else INK); x+=o[2][i]
        y+=66
    elif k=='tr':
        h=row_h(o[1],o[2]); x=PAD
        for i,c in enumerate(o[1]):
            d.rectangle([x,y,x+o[2][i],y+h],fill=CARD,outline=LINE); yy=y+14
            for ln in wrap(c,fb if i==0 else ft,o[2][i]-36): d.text((x+18,yy),ln,font=fb if i==0 else ft,fill=MUTE if i==0 else INK); yy+=LH
            x+=o[2][i]
        y+=h
    elif k=='h': d.text((PAD,y),o[1],font=fh,fill=o[2]); y+=58
    elif k=='p':
        for ln in wrap(o[1],ft,W-2*PAD-20): d.text((PAD+10,y),ln,font=ft,fill=o[2]); y+=LH
        y+=8
    elif k=='g': y+=o[1]
im.save(out,quality=92); print(im.size)
