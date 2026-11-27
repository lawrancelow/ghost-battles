import numpy as np, onnxruntime as ort, cv2
S=None
def sess():
    global S
    if S is None: S=ort.InferenceSession('/home/claude/models/lama_fp32.onnx',providers=['CPUExecutionProvider'])
    return S
def run512(img,mask):
    x=cv2.resize(img,(512,512),interpolation=cv2.INTER_AREA).astype(np.float32)/255.
    m=(cv2.resize(mask.astype(np.uint8)*255,(512,512),interpolation=cv2.INTER_NEAREST)>127).astype(np.float32)
    o=sess().run(None,{'image':x.transpose(2,0,1)[None],'mask':m[None,None]})[0][0].transpose(1,2,0)
    if o.max()<=1.5: o=o*255
    return np.clip(o,0,255).astype(np.uint8)
def inpaint(img,mask,pad=1.7,maxside=1100):
    """img BGR uint8, mask bool. fills per component with square windows"""
    out=img.copy(); H,W=mask.shape
    n,lab,st,_=cv2.connectedComponentsWithStats(mask.astype(np.uint8),8)
    for i in range(1,n):
        x,y,w,h,a=st[i]
        cx,cy=x+w/2,y+h/2; s=int(min(max(w,h)*pad+40,max(H,W)))
        s=max(s,256)
        x0=int(max(0,min(W-s,cx-s/2))) if s<=W else 0; y0=int(max(0,min(H-s,cy-s/2))) if s<=H else 0
        x1=min(W,x0+s); y1=min(H,y0+s)
        win=out[y0:y1,x0:x1]; mw=(lab[y0:y1,x0:x1]>0)&mask[y0:y1,x0:x1]
        o=run512(win[:,:,::-1].copy(),mw)[:,:,::-1]
        o=cv2.resize(o,(x1-x0,y1-y0),interpolation=cv2.INTER_CUBIC)
        win[mw]=o[mw]
    return out

def inpaint_tiled(img,mask,T=512,stride=320):
    out=img.copy(); rem=mask.copy(); H,W=mask.shape
    ys,xs=np.where(mask)
    if len(ys)==0: return out
    # iterate windows centred around remaining hole, largest-hole-first order
    for _ in range(200):
        if not rem.any(): break
        ys,xs=np.where(rem)
        # pick top-most remaining row cluster to grow fill from known context
        y=ys.min(); xr=xs[ys<y+40]; cx=int(np.median(xr))
        x0=int(np.clip(cx-T//2,0,max(0,W-T))); y0=int(np.clip(y-T//4,0,max(0,H-T)))
        x1=min(W,x0+T); y1=min(H,y0+T)
        win=out[y0:y1,x0:x1]; mw=rem[y0:y1,x0:x1].copy()
        if win.shape[0]!=T or win.shape[1]!=T:
            o=run512(win[:,:,::-1].copy(),mw)[:,:,::-1]; o=cv2.resize(o,(x1-x0,y1-y0),interpolation=cv2.INTER_CUBIC)
        else:
            o=run512(win[:,:,::-1].copy(),mw)[:,:,::-1]
        # only accept filled pixels in upper 3/4 of window unless window touches image bottom (so next window has context)
        acc=mw.copy()
        if y1<H: acc[int(0.75*(y1-y0)):,:]=False
        if not acc.any(): acc=mw
        win[acc]=o[acc]; rem[y0:y1,x0:x1][acc]=False
    return out
