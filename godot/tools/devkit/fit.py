import numpy as np, sys
from PIL import Image
from scipy import ndimage as nd
def cut_mask(rgb):
    a=np.array(rgb.convert('RGB')).astype(int)
    dist=255-a.min(axis=2)
    white=dist<22
    lab,n=nd.label(white)
    border=set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]])))-{0}
    bg=np.isin(lab,list(border))
    return a,dist,bg
def rgba_from(path_or_img, box=None):
    im=Image.open(path_or_img) if isinstance(path_or_img,str) else path_or_img
    im=im.convert('RGB')
    if box: im=im.crop(box)
    a,dist,bg=cut_mask(im)
    alpha=np.where(bg,0,255).astype(float)
    # soft edge: pixels of fg adjacent to bg get alpha by darkness
    edge=nd.binary_dilation(bg,iterations=2)&~bg
    alpha[edge]=np.clip(dist[edge]*6,0,255)
    # remove tiny islands
    fg=alpha>0
    L,n=nd.label(nd.binary_dilation(fg,iterations=3))
    sizes=nd.sum(fg,L,range(1,n+1))
    keep=np.isin(L,[i+1 for i,s in enumerate(sizes) if s>=max(400,0.02*sizes.max())])
    alpha[~keep]=0
    out=np.dstack([a,alpha]).astype(np.uint8)
    o=Image.fromarray(out,'RGBA'); return o.crop(o.getbbox())
def bbox_of(path):
    im=Image.open(path).convert('RGBA'); return im.size, im.getbbox()
def place(part, ref_path, anchor='center', scale_mode='fit'):
    (W,H),(x0,y0,x1,y1)=bbox_of(ref_path)
    bw,bh=x1-x0,y1-y0
    s=min(bw/part.width,bh/part.height) if scale_mode=='fit' else bh/part.height
    p=part.resize((max(1,round(part.width*s)),max(1,round(part.height*s))),Image.LANCZOS)
    cx=(x0+x1)/2
    if anchor=='top': px,py=round(cx-p.width/2),y0
    elif anchor=='bottom': px,py=round(cx-p.width/2),y1-p.height
    else: px,py=round(cx-p.width/2),round((y0+y1)/2-p.height/2)
    can=Image.new('RGBA',(W,H),(0,0,0,0)); can.alpha_composite(p,(max(0,px),max(0,py)) if px>=0 and py>=0 else (0,0))
    if px<0 or py<0:
        can=Image.new('RGBA',(W,H),(0,0,0,0)); can.paste(p,(px,py),p)
    return can

def rgba_from2(path_or_img, box=None, RX=0.36, BIG=10**9):
    im=Image.open(path_or_img) if isinstance(path_or_img,str) else path_or_img
    im=im.convert('RGB')
    if box: im=im.crop(box)
    a,dist,bg=cut_mask(im)
    H,W=dist.shape
    white=dist<24
    lab,n=nd.label(white)
    yy,xx=np.mgrid[0:H,0:W]
    cy,cx=H/2,W/2
    extra=np.zeros_like(bg)
    for k,s in enumerate(nd.find_objects(lab)):
        m=lab[s]==k+1
        if bg[s][m].any(): continue
        area=m.sum()
        if area<8: continue
        my=(yy[s][m]).mean(); mx=(xx[s][m]).mean()
        r=((mx-cx)/(W*RX))**2+((my-cy)/(H*RX))**2
        if r>1 or area>BIG: extra[s]|=m
    bgall=bg|extra
    alpha=np.where(bgall,0,255).astype(float)
    edge=nd.binary_dilation(bgall,iterations=2)&~bgall
    alpha[edge]=np.clip((dist[edge]-8)*7,0,255)
    fg=alpha>0
    L,n=nd.label(nd.binary_dilation(fg,iterations=3))
    if n:
        sizes=nd.sum(fg,L,range(1,n+1))
        keep=np.isin(L,[i+1 for i,s in enumerate(sizes) if s>=max(400,0.02*sizes.max())])
        alpha[~keep]=0
    out=np.dstack([a,alpha]).astype(np.uint8)
    o=Image.fromarray(out,'RGBA'); return o.crop(o.getbbox())
