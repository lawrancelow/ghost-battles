import sys,os,json,cv2,numpy as np
d=sys.argv[1];L=json.load(open(os.path.join(d,'layout.json')))['layers'][1:]
tiles=[]
for l in L:
    im=cv2.imread(os.path.join(d,l['file']),cv2.IMREAD_UNCHANGED);h,w=im.shape[:2]
    s=260/max(h,w);im=cv2.resize(im,(max(1,int(w*s)),max(1,int(h*s))))
    h,w=im.shape[:2];bg=np.zeros((280,280,3),np.uint8);bg[:]=(60,200,60)
    yy,xx=np.mgrid[0:280,0:280];bg[((yy//14+xx//14)%2)==0]=(80,220,80)
    a=im[:,:,3:4]/255.;y0,x0=(280-h)//2,(280-w)//2
    bg[y0:y0+h,x0:x0+w]=(im[:,:,:3]*a+bg[y0:y0+h,x0:x0+w]*(1-a)).astype(np.uint8)
    cv2.putText(bg,l['name'],(5,20),0,0.6,(255,255,255),2);tiles.append(bg)
cv2.imwrite(sys.argv[2],np.hstack(tiles))
