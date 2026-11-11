from PIL import Image
import numpy as np
im=Image.open('/home/claude/gen_art/gb_tower_rooms_sheet.jpg').convert('RGB'); a=np.asarray(im).astype(int).mean(axis=2)
def runs(prof,n):
  dark=prof<6; segs=[]; i=0; L=len(prof)
  while i<L:
    if not dark[i]:
      j=i
      while j<L and not dark[j]: j+=1
      if j-i>60: segs.append((i,j))
      i=j
    else: i+=1
  return segs
cols=runs(a.mean(axis=0),4); rows=runs(a.mean(axis=1),2); print(cols,rows)
names=['room_mahjong','room_gamer','room_nurse','room_helper','room_gym','room_shopper','room_carpark','room_lobby']
k=0
for r in rows:
  for c in cols:
    im.crop((c[0]+2,r[0]+2,c[1]-2,r[1]-2)).resize((420,420),Image.LANCZOS).save(f'/home/claude/lyg/assets/{names[k]}.webp',quality=82); k+=1
print(k)
