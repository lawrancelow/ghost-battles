from PIL import Image, ImageDraw, ImageFont
F='/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc'
import os
if not os.path.exists(F):
    import glob; F=[f for f in glob.glob('/usr/share/fonts/**/*CJK*',recursive=True)][0]
def font(s): return ImageFont.truetype(F,s)
G='/home/claude/wt/uiart/art/ui/gen/'
dirs=[('A','辦公室鐵櫃','A_office_gpt.png','A_office_mix_v4.png'),
      ('C','精緻繪本','C_storybook_gpt.png','C_picbook_v2.png'),
      ('E','告示板','E_board_gpt.png','E_board_v2_seamfix.png'),
      ('G','月洞門','G_moongate_gpt.png','G_moongate_v2.png'),
      ('H','舊電視','H_crt_gpt.png','H_crt_v1_seamfix.png'),
      ('I','當舖帳簿','I_ledger_gpt.png','I_ledger_v2.png')]
def fit(p,w,h):
    im=Image.open(p).convert('RGB'); im.thumbnail((w,h)); c=Image.new('RGB',(w,h),(24,20,18)); c.paste(im,((w-im.width)//2,(h-im.height)//2)); return c
# sheet 1: ChatGPT 6
W,H=1400,2200; s=Image.new('RGB',(W,H),(18,15,14)); d=ImageDraw.Draw(s)
d.text((40,25),'面板風格 6 方向（ChatGPT Plus 生成，以標題畫面為畫風參考）',font=font(44),fill=(240,220,180))
d.text((40,85),'圖上故意不放字，正式版文字由程式疊上。請直接回字母選擇，可混搭。',font=font(28),fill=(190,175,150))
cw,ch=440,960
for i,(k,n,g,_) in enumerate(dirs):
    x=20+(i%3)*(cw+20); y=140+(i//3)*(ch+70)
    s.paste(fit(g,cw,ch),(x,y)); d.text((x,y+ch+8),f'{k}  {n}',font=font(36),fill=(255,200,120))
s.save('HC_GB_UI_ChatGPT_6Directions.jpg',quality=88)
# sheet 2: compare
s=Image.new('RGB',(W,H),(18,15,14)); d=ImageDraw.Draw(s)
d.text((40,20),'同方向對比：左 ChatGPT ／ 右 Gemini',font=font(44),fill=(240,220,180))
cw,ch=330,640; rows=[dirs[:3],dirs[3:]]
for r,row in enumerate(rows):
    for j,(k,n,g,gm) in enumerate(row):
        x=20+j*460; y=100+r*(ch+420)
        s.paste(fit(g,cw//1*1-110,ch),(x,y)); s.paste(fit(G+gm,220,ch),(x+225,y))
        d.text((x,y+ch+8),f'{k} {n}',font=font(32),fill=(255,200,120))
        d.text((x,y+ch+52),'左 ChatGPT　右 Gemini',font=font(22),fill=(190,175,150))
d.text((40,H-200),'ChatGPT：專業商業手遊質感、材質細緻、構圖有層次、蠟筆顆粒是表面紋理，不幼稚。',font=font(28),fill=(220,220,200))
d.text((40,H-150),'Gemini：粗糙塗鴉感重、會亂加字和手機狀態列、解析度低。',font=font(28),fill=(220,220,200))
s.save('HC_GB_UI_ChatGPT_vs_Gemini.jpg',quality=88)
print('ok')
