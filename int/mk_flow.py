# 拼整合版走查總覽：python3 mk_flow.py（讀 raw/<tag>/*.png，全部來自 int-all 實機）
from PIL import Image, ImageDraw, ImageFont
import os
R='/home/claude/meeting/int/raw/'
F='/usr/share/fonts/opentype/noto/NotoSansCJK-DemiLight.ttc'
f1=ImageFont.truetype(F,26); f2=ImageFont.truetype(F,40)
def first(*c):
    for x in c:
        if x.startswith('/') and os.path.exists(x): return x
        if os.path.exists(R+x): return R+x
    return None
rows=[
('男主：新開場',[('黃泉路','opening/m_op2_road.png'),('地府集團大堂','opening/m_op2_lobby.png'),('龐總辦公室','opening/m_op2_office.png'),('孟婆遞湯','opening/m_op2_soup.png'),('流放蓋章','opening/m_op2_exile_cg4.png','opening/m_op2_exile.png'),('到荒村當村長','opening/m_op2_arrive.png')]),
('女主：新開場',[('黃泉路','opening/f_opf2_road.png'),('地府集團大堂','opening/f_opf2_lobby.png'),('龐總辦公室','opening/f_opf2_office.png'),('孟婆遞湯','opening/f_opf2_soup_cg3.png','opening/f_opf2_soup.png'),('流放蓋章','opening/f_opf2_exile_cg2.png','opening/f_opf2_exile.png'),('到荒村當村長','opening/f_opf2_arrive.png')]),
('荒村重建與 KPI 考核',[('荒村廢墟','rebuild/01_ruins.png'),('清理','rebuild/02_house_cleared.png'),('搭棚','rebuild/03_scaffold.png'),('開張','rebuild/04_house_open.png'),('全部重建完成','rebuild/05_done.png'),('KPI 考核卡','kpi/sheet_A_v4.png','kpi/sheet_A.png'),('迷霧上的考核牌','kpi/fog_A_kpi_v3.png'),('逾期：Bryan 搶功橫幅','kpi/bryan_banner.png')]),
('酒館、化寶爐與 KPI 劇情插圖',[('陰間酒館（招雜鬼）','/tmp/xshots/tavern.png'),('化寶爐','/tmp/xshots/furnace.png'),('何大睡登場','/home/claude/meeting/vil2/kpi/cg/he_wake.png'),('錢不漏登場','/home/claude/meeting/vil2/kpi/cg/qian_bite.png'),('Dato\' 冥金匾','/home/claude/meeting/vil2/kpi/cg/dato_plaque.png'),('糯婆試食','/home/claude/meeting/vil2/kpi/cg/nuopo_taste.png'),('收賄成功','/home/claude/meeting/vil2/kpi/cg/bribe_m.png'),('被抓包','/home/claude/meeting/vil2/kpi/cg/caught.png')]),
('過勞鬼市集（食街）',[('正常營業','mk/s01_normal.png'),('雙貨貨架','mk/s04_shelf_dual.png'),('巡邏面板','mk/s05_panel_patrol.png'),('櫃檯面板','mk/s06_panel_counter.png'),('偷錢：巡邏鬼去追','mk/s07_steal_cash_chase.png'),('插隊','mk/s09_cut_queue.png'),('吵架打鬧','mk/s10_brawl.png'),('店員過勞趴下','mk/s13_overwork.png')]),
('市集第二階段',[('加班','m2/s1_overtime.png'),('子時高峰＋限時大客','m2/s4_rush_peak_vip_chain.png'),('潮流榜與名聲','m2/s6_trend_renown.png'),('里程碑','m2/s7_milestone.png'),('街組合','m2/s8_street_combo.png'),('評論家','m2/s9_critic.png'),('熟客','m2/s10_regular.png'),('市集開張插圖','/home/claude/meeting/vil2/kpi/cg/market_open_m.png')]),
('野外第 1 章',[('地圖總覽','post/16_map_overview.png'),('普通據點：空置','post/03_card_vacant.png'),('派主任','post/04_card_pick.png'),('駐點營業＋收銀箱','post/06_card_open.png'),('幫派反撲','post/08_raid_siege.png'),('停業，要打回來','post/11_card_retake.png'),('名鬼據點：首殺','post/12_card_named_first.png'),('名鬼請假倒數','post/14_card_named_leave.png')]),
]
TW,TH=330,715; pad=12; top=40; head=64; N=8
W=pad+N*(TW+pad); H=pad+sum(head+top+TH+pad for _ in rows)
o=Image.new('RGB',(W,H),(27,22,32)); d=ImageDraw.Draw(o); y=pad; miss=[]
for title,tiles in rows:
    d.text((pad,y+8),title,font=f2,fill=(255,214,120)); y+=head
    for i,t in enumerate(tiles):
        x=pad+i*(TW+pad); p=first(*t[1:])
        d.text((x,y+4),t[0],font=f1,fill=(235,225,240))
        if p: o.paste(Image.open(p).convert('RGB').resize((TW,TH),Image.LANCZOS),(x,y+top))
        else: miss.append(t[0]); d.rectangle((x,y+top,x+TW,y+top+TH),outline=(120,100,130)); d.text((x+20,y+top+300),'（未截到）',font=f1,fill=(160,140,170))
    y+=top+TH+pad
o.save('/home/claude/meeting/int/flow_overview.jpg',quality=86); print(o.size,'missing',miss)
