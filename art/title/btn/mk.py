import sys, numpy as np, cv2
from PIL import Image, ImageDraw, ImageFont, ImageFilter
src, dst = sys.argv[1], sys.argv[2]
im = Image.open(src).convert('RGBA'); a = np.array(im)
rgb = a[:,:,:3].astype(int)
# 黃牌範圍內的紅字：R 高、G 低
x0,y0,x1,y1 = 56,56,124,152
reg = rgb[y0:y1,x0:x1]
red = (reg[:,:,0]>140)&(reg[:,:,1]<120)&(reg[:,:,0]-reg[:,:,1]>60)
mask = np.zeros(rgb.shape[:2],np.uint8); mask[y0:y1,x0:x1][red]=255
mask = cv2.dilate(mask, np.ones((3,3),np.uint8), 2)
bgr = cv2.cvtColor(a[:,:,:3], cv2.COLOR_RGB2BGR)
fix = cv2.inpaint(bgr, mask, 5, cv2.INPAINT_TELEA)
# 加回黃紙紋理噪點
yel = cv2.cvtColor(fix, cv2.COLOR_BGR2RGB).astype(np.float32)
noise = np.random.RandomState(3).normal(0, 9, yel.shape[:2])[:,:,None]
m3 = (mask>0)[:,:,None]
yel = np.where(m3, np.clip(yel+noise,0,255), yel)
out = a.copy(); out[:,:,:3] = yel.astype(np.uint8)
base = Image.fromarray(out)
# 紅色毛筆「加班」直排，跟吊牌傾斜
font = ImageFont.truetype(sys.argv[3], 40)
L = Image.new('L',(90,110),0); d = ImageDraw.Draw(L)
for i,ch in enumerate('加班'):
    w = d.textlength(ch, font=font); d.text(((90-w)/2, 6+i*44), ch, font=font, fill=255, stroke_width=1, stroke_fill=255)
L = L.rotate(float(sys.argv[4]), resample=Image.BICUBIC, center=(45,55))
# 粉彩筆觸：邊緣糙化＋顆粒
la = np.array(L).astype(np.float32)/255
grain = np.random.RandomState(7).uniform(0.55,1.0,la.shape)
la = la*grain
col = Image.new('RGBA',L.size,(178,40,28,255)); col.putalpha(Image.fromarray((np.clip(la,0,1)*235).astype(np.uint8)))
base.alpha_composite(col,(int(sys.argv[5]),int(sys.argv[6])))
base.save(dst, 'WEBP', quality=95, method=6)
base.crop((40,0,160,177)).resize((360,531)).save(dst+'.tag.png')
