# 出遊戲圖：eqi_<id>_i.webp（256 斜放／原樣 icon）＋ eqi_<id>.webp（512 直立，揸位底中間）
import sys, os, math, numpy as np
from PIL import Image
sys.path.insert(0,'/home/claude/art/eqwork'); import mkgame
OUT='/home/claude/art/p45/game'; os.makedirs(OUT,exist_ok=True)
def place(r):
    a=np.asarray(r)[...,3]; ys,xs=np.where(a>16); r=r.crop((xs.min(),ys.min(),xs.max()+1,ys.max()+1))
    s=min(470/r.height,500/r.width); r=r.resize((round(r.width*s),round(r.height*s)),Image.LANCZOS)
    a=np.asarray(r)[...,3]; h=r.height; xs=np.where(a[int(h*0.88):]>40)[1]; cx=xs.mean() if len(xs) else r.width/2
    can=Image.new('RGBA',(512,512),(0,0,0,0)); x=int(round(256-cx)); x=max(0,min(512-r.width,x))
    can.paste(r,(x,508-r.height),r); return can
FLIP=False
def pca_up(im):
    a=np.asarray(im)[...,3]; ys,xs=np.where(a>40); c=np.cov(np.vstack([xs-xs.mean(),ys-ys.mean()]))
    w,v=np.linalg.eigh(c); vx,vy=v[:,1]
    ang=math.degrees(math.atan2(-vy,vx))   # 長軸同水平夾角（逆時針為正）
    if ang<0: ang+=180
    rot=90-ang                              # PIL rotate 逆時針
    if FLIP: rot+=180
    return place(im.rotate(rot,resample=Image.BICUBIC,expand=True)), rot
def main():
    E='/home/claude/art/out/EquipArt'
    P8='eq_guanban eq_paperphone eq_fengyou eq_jinzheng ex_lg_dpl_king ex_lg_egs_king ex_lg_jsj_jiangchen ex_lg_klj_king ex_lg_sgj_king ex_lg_ssg_king ex_lg_wkj_king ex_lg_zzj_king'.split()
    FIX='ex_nw_niexiaoqian ex_bm_taotie ex_bm_hou'.split()
    PCA={'eq_guanban','eq_paperphone','ex_lg_klj_king','ex_lg_ssg_king','ex_nw_niexiaoqian'}
    for i in P8+FIX:
        src=os.path.join(E,'HC_%s.png'%i) if i in P8 else '/home/claude/art/p45/src/HC_%s.png'%i
        im=Image.open(src).convert('RGBA')
        im.resize((256,256),Image.LANCZOS).save(os.path.join(OUT,'eqi_%s_i.webp'%i),'WEBP',quality=92,method=6)
        global FLIP; FLIP = i=='ex_lg_ssg_king'
        if i in PCA: h,rot=pca_up(im); print(i,'pca rot %.1f'%rot)
        else: h=im; print(i,'up')
        h.save(os.path.join(OUT,'eqi_%s.webp'%i),'WEBP',quality=92,method=6)
# 另外：涼茶壺／保安電筒／舊鬧鐘／銀雞 4 件（直立原樣）用 mkgame.main([], ['eq_liangchapot','eq_dianzhan','eq_naozhong','eq_yinji'], OUT)
main()
