# 拼開場總覽：python3 mkflow.py（讀同目錄的 m_*.png / f_*.png）
from PIL import Image, ImageDraw, ImageFont
import glob
font=None
for f in glob.glob('/home/claude/wt/opening/godot/fonts/*.otf')+glob.glob('/home/claude/wt/opening/godot/fonts/*.ttf'):
    try: font=ImageFont.truetype(f,26); break
    except Exception: pass
names={'road':'1 黃泉路（黑白無常）','lobby':'2 總部大堂','office':'3 龐總辦公室','soup':'4 孟婆遞湯・拒喝','exile':'5 流放','arrive':'6 到荒村當村長'}
for sex,pre in (('m','op2_'),('f','opf2_')):
    tiles=[(names[k],(sorted(glob.glob(f'{sex}_{pre}{k}_cg*.png')) or [f'{sex}_{pre}{k}.png'])[0]) for k in names]
    ims=[Image.open(f).convert('RGB') for _,f in tiles]
    w,h=ims[0].size; pad=14; top=44
    o=Image.new('RGB',(3*(w+pad)+pad,2*(h+top+pad)+pad),(27,22,32)); d=ImageDraw.Draw(o)
    for i,(t,_) in enumerate(tiles):
        x=pad+(i%3)*(w+pad); y=pad+(i//3)*(h+top+pad)
        d.text((x,y+6),('男主 ' if sex=='m' else '女主 ')+t,fill=(240,220,160),font=font); o.paste(ims[i],(x,y+top))
    o.save(f'opening_flow_{sex}.jpg',quality=88)
