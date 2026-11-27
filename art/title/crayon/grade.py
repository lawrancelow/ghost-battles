# 降飽和：紅橙黃 → 暗磚紅／暗朱、土黃；紫 → 灰紫；保留黑描邊和明暗對比
import sys, numpy as np
from PIL import Image
src,out=sys.argv[1:3]; k=float(sys.argv[3]) if len(sys.argv)>3 else 1.0
im=Image.open(src).convert('RGBA'); a=im.getchannel('A')
hsv=np.array(im.convert('RGB').convert('HSV')).astype(np.float32)/255.0
h,s,v=hsv[...,0],hsv[...,1],hsv[...,2]
warm=(h<0.17)|(h>0.93); purp=(h>0.66)&(h<=0.93)
# 暖色：飽和 ×0.58、亮度 ×0.80，黃往橙偏（變土黃）
s=np.where(warm,s*(1-0.22*k),s); v=np.where(warm,v*(1-0.36*k),v)
h=np.where(warm&(h<0.17)&(h>0.06),h-(h-0.06)*0.35*k,h)
# 紫：飽和 ×0.45、亮度 ×0.78
s=np.where(purp,s*(1-0.50*k),s); v=np.where(purp,v*(1-0.35*k),v)
# 淺色（工作證、小鬼魂臉）略降亮
v=np.where((s<0.25)&(v>0.8),v*(1-0.12*k),v)
o=np.dstack([h,np.clip(s,0,1),np.clip(v,0,1)])*255
rgb=Image.fromarray(o.astype(np.uint8),'HSV').convert('RGB')
r=rgb.convert('RGBA'); r.putalpha(a); r.save(out); print(out)
