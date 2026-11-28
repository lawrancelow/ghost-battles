import sys,os
from PIL import Image, ImageDraw, ImageFont
S='/home/claude/docs/post_shots/'; out=sys.argv[1]
FD='/usr/share/fonts/opentype/noto/'
def F(sz,b=False): return ImageFont.truetype(FD+('NotoSansCJK-Bold.ttc' if b else 'NotoSansCJK-Regular.ttc'),sz,index=3)
items=[('01_card_post_before','① 普通據點出擊卡：打贏就佔領'),('02_sign_vacant','② 佔領後：木牌「空缺」'),('03_card_vacant','③ 駐點卡：還沒有主任'),('04_card_pick','④ 選誰去當主任'),
       ('05_sign_open_till','⑤ 營業中：木牌產量＋收銀箱紅點'),('06_card_open','⑥ 駐點卡：產量、收銀箱、守備'),('07_sign_till_full','⑦ 收銀箱滿了：點木牌收錢'),('08_raid_siege','⑧ 幫派反撲來襲：點我迎戰'),
       ('09_card_siege_feed','⑨ 也可以派包子打發'),('10_sign_lost','⑩ 沒守住：停業整頓'),('11_card_retake','⑪ 出擊卡：打贏就收復'),('12_card_named_first','⑫ 名鬼據點：首殺必掉＋四檔掉落'),
       ('13_sign_named_leave','⑬ 名鬼請假倒數（代班頂著）'),('14_card_named_leave','⑭ 請假期間的出擊卡'),('15_tier_0','⑮ 結算：很少'),('15_tier_3','⑯ 結算：大爆')]
items=[(a,b) for a,b in items if os.path.exists(S+a+'.png')]
cols=4; cw=450; pad=24; cap=64
ims=[Image.open(S+a+'.png').convert('RGB') for a,_ in items]
ch=int(ims[0].height*cw/ims[0].width)
rows=(len(items)+cols-1)//cols
W=pad+cols*(cw+pad); H=110+rows*(ch+cap+pad)+pad
im=Image.new('RGB',(W,H),'#1b1620'); d=ImageDraw.Draw(im)
d.text((pad,24),'野外第 1 章：外派駐點＋名鬼據點可刷（實機截圖）',font=F(46,True),fill='#efe6f2')
for i,((a,b),g) in enumerate(zip(items,ims)):
    x=pad+(i%cols)*(cw+pad); y=110+(i//cols)*(ch+cap+pad)
    d.text((x,y+8),b,font=F(27,True),fill='#ffd27a')
    im.paste(g.resize((cw,ch),Image.LANCZOS),(x,y+cap))
im.save(out,quality=90); print(im.size,len(items))
