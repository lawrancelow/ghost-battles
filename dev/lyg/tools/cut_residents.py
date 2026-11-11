from PIL import Image, ImageDraw, ImageFilter
import numpy as np
src=Image.open('/home/claude/gen_art/gb_residents_sheet.png').convert('RGB'); W,H=src.size
names=['res_gamer','res_uncle','res_granny','res_helper','res_mjaunty','res_shopper','res_collector','res_guard','res_ot','res_gym']
cw=W/5; rh=H/2
for i,nm in enumerate(names):
  c=i%5; r=i//5; box=(int(c*cw)+2,int(r*rh)+2,int((c+1)*cw)-2,int((r+1)*rh)-2)
  im=src.crop(box); w,h=im.size
  a=np.array(im).astype(int)
  # 背景：同灰色接近且由邊緣連通
  d=np.abs(a-np.array([128,128,128])).max(axis=2)
  bgc=d<34
  from collections import deque
  seen=np.zeros((h,w),bool); q=deque()
  for x in range(w):
    for y in (0,h-1):
      if bgc[y,x]: seen[y,x]=1; q.append((y,x))
  for y in range(h):
    for x in (0,w-1):
      if bgc[y,x] and not seen[y,x]: seen[y,x]=1; q.append((y,x))
  while q:
    y,x=q.popleft()
    for dy,dx in ((1,0),(-1,0),(0,1),(0,-1)):
      ny,nx=y+dy,x+dx
      if 0<=ny<h and 0<=nx<w and not seen[ny,nx] and bgc[ny,nx]: seen[ny,nx]=1; q.append((ny,nx))
  import scipy.ndimage as nd
  lab,nl=nd.label(bgc&~seen)
  if nl:
    sz=nd.sum(np.ones_like(lab),lab,range(1,nl+1))
    for k,z in enumerate(sz,1):
      m=(lab==k)
      if z>250 and d[m].mean()<14 and abs(a[m].mean()-128)<10: seen|=m
  # 去走細碎孤島（隔籬格嘅碎片）
  fg=~seen; lab2,n2=nd.label(fg)
  if n2>1:
    sz2=nd.sum(np.ones_like(lab2),lab2,range(1,n2+1)); keep=1+int(np.argmax(sz2)); seen|=(lab2!=keep)&fg
  alpha=np.where(seen,0,255).astype(np.uint8)
  A=Image.fromarray(alpha).filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(0.8))
  rgba=im.convert('RGBA'); rgba.putalpha(A)
  bb=rgba.getbbox(); rgba=rgba.crop(bb)
  s=420/rgba.height; rgba=rgba.resize((max(1,int(rgba.width*s)),420),Image.LANCZOS)
  rgba.save(f'/home/claude/lyg/assets/{nm}.webp',quality=86); print(nm,rgba.size)
