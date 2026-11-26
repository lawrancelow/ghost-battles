# 做工工具圖 → assets/spr/tool_<id>.webp（256）＋ TOOL_ART 參數（uv：揸位 grip、軸向 tip、工作面 edge、顯示大小 sz）
# [p45] 老闆：鋼杯、印仔顯示偏大（杯 0.9、印 0.95；原 0.6／0.72 喺遊戲細到睇唔清）
# 做法：每件喺原圖量工作面 a、b、法向 n（圖 uv），揀軸向 U（工具「向上」嗰個方向；工作面沿軸嘅工具 U＝n，即係旋轉修正），
#       再揀 sz（圖高＝L×sz），反計 grip，令工作面喺工具框嘅位置同程序線稿（EDGE，24 格框）一樣——動作同測試唔使改。
import json, math, numpy as np
from PIL import Image
SRC='/home/claude/art/out/WorkTools/HC_Tool_%s.png'; OUT='/home/claude/art/p45/tools'
EDGE={  # 程序線稿工作面（同 work_anim.gd EDGE 一樣）
 "ladle": [(-4.8,-17),(4.8,-17)], "needle": [(0,-24),(0,-24)], "pbrush": [(-3.6,-24.5),(3.6,-24.5)], "brush": [(-3.6,-24.5),(3.6,-24.5)],
 "fan": [(0,-11),(0,-23)], "chopper": [(7.1,-20.5),(6.2,-9.0)], "pestle": [(-3.4,-25),(3.4,-25)], "fork": [(-3.4,-25),(3.4,-25)],
 "plane": [(-10,0),(10,0)], "pumph": [(0,0),(0,0)], "pin": [(-10,2.2),(10,2.2)], "shaker": [(-3,-24),(3,-24)], "saw": [(3.8,-7.9),(3.8,-24.2)],
 "screwdriver": [(0,-24),(0,-24)], "stamp": [(-5,-1),(5,-1)], "paddle": [(-2.6,-25),(2.6,-25)], "tapper": [(6.0,-19.4),(5.4,-16.6)],
 "cup": [(-4.4,-16),(4.4,-16)], "tongs": [(-1.4,-24),(1.4,-24)], "spatula": [(-6,-23),(6,-23)]}
def nz(v): v=np.array(v,float); return v/np.linalg.norm(v)
# id: (圖, a, b, n, U, sz, 名, 處理)
T={
 "ladle":  ("Ladle", (0.423,0.30),(0.423,0.05),(-1,0),(1,0),1.15,"勺口（原圖勺口向右 → 左右翻再轉 90°：勺口向返揸位同程序線稿一樣，倒轉用時柄向後）","flip"),
 "needle": ("Needle",(0.465,0.045),(0.465,0.045),None,None,None,"針尖",None),
 "pbrush": ("OilBrush",(0.69,0.40),(0.69,0.06),(1,0),(1,0),0.9,"掃毛（原圖毛向右 → 旋轉令毛沿軸）",None),
 "brush":  ("PasteBrush",(0.34,0.07),(0.68,0.07),(0,-1),(0,-1),1.0,"掃毛",None),
 "fan":    ("PalmFan",(0.5,0.50),(0.5,0.08),(1,0),(0,-1),1.05,"扇面",None),
 "chopper":("Parang",(0.565,0.12),(0.552,0.55),(1,0.03),(0,-1),1.1,"刀口（刃在右）",None),
 "pestle": ("Pestle",None,None,None,None,1.15,"杵頭",None),
 "fork":   ("Pitchfork",(0.63,0.22),(0.63,0.06),(1,-0.15),(1,-0.15),1.1,"叉齒（原圖齒向右彎 → 旋轉令齒沿軸）",None),
 "plane":  ("Plane",(0.70,0.93),(0.70,0.08),(1,0),(-1,0),0.98,"刨底刀口（原圖刨底向右 → 轉 90° 刨底向落）",None),
 "pumph":  ("Pump",None,None,None,None,None,"泵桿底","pump"),
 "pin":    ("RollingPin",(0.59,0.80),(0.59,0.17),(1,0),(-1,0),1.1,"碌面（原圖直放 → 轉 90° 打橫）",None),
 "shaker": ("SaltTube",None,None,None,None,1.27,"鹽筒孔（原圖筒口向右上 → 旋轉令筒口沿軸）",None),
 "saw":    ("Saw",(0.556,0.08),(0.612,0.65),None,(0,-1),1.19,"鋸齒（齒在右）",None),
 "screwdriver": ("Screwdriver",None,None,None,None,None,"批咀（直立向上）",None),
 "stamp":  ("Stamp",(0.20,0.93),(0.80,0.93),(0,1),(0,-1),0.95,"印面",None),
 "paddle": ("StirStick",(0.42,0.05),(0.58,0.05),(0,-1),(0,-1),1.2,"攪板頭",None),
 "tapper": ("TapKnife",(0.585,0.105),(0.572,0.075),(1,-0.2),(0,-1),1.0,"膠刀鉤口（鉤在右）",None),
 "cup":    ("TehTarikCup",None,None,None,None,0.9,"杯口（原圖杯口向右 → 左右翻、轉 90°，柄喺後）","flip"),
 "tongs":  ("Tongs",(0.48,0.06),(0.56,0.07),(0,-1),(0,-1),1.12,"夾嘴",None),
 "spatula":("WokSpatula",(0.535,0.05),(0.575,0.075),(0,-1),(0,-1),1.1,"鏟口",None),
}
def alpha(im): return np.asarray(im)[...,3]
def ends(im):   # 直身工具：最頂／最底幾行嘅中心
    a=alpha(im); ys,xs=np.where(a>60); y0,y1=ys.min(),ys.max()
    t=xs[ys<=y0+4].mean(); b=xs[ys>=y1-4].mean()
    return (t/512,y0/512),(b/512,(y1+1)/512)
def solve(a,b,n,U,sz,E):
    a=np.array(a);b=np.array(b);n=nz(n);U=nz(U)
    # R：圖向量 → 工具框（U → (0,-1)）
    th=math.atan2(-1,0)-math.atan2(U[1],U[0]); c,s=math.cos(th),math.sin(th)
    R=lambda v: np.array([c*v[0]-s*v[1], s*v[0]+c*v[1]]); Ri=lambda v: np.array([c*v[0]+s*v[1], -s*v[0]+c*v[1]])
    mid=(a+b)/2; Em=(np.array(E[0])+np.array(E[1]))/2
    G=mid-Ri(Em/(sz*24.0))
    # 檢查：工作面喺工具框
    ta=R(a-G)*sz*24; tb=R(b-G)*sz*24; tn=R(n)
    return G, G+U*0.5, (ta,tb,tn)
out={}
for k,(f,a,b,n,U,sz,nm,proc) in T.items():
    im=Image.open(SRC%f).convert('RGBA')
    if proc=='flip': im=im.transpose(Image.FLIP_LEFT_RIGHT)
    if proc=='pump':
        A=np.asarray(im).copy()
        # 手柄：T 柄＋泵桿（原圖 y 428..490，x 140..316），桿加長到 20 格，轉 180° → T 喺頂
        h=im.crop((140,431,316,490)); rod=im.crop((219,436,239,446))
        hu=h.rotate(180)   # T 喺頂、桿向下（59 高；T 中心約 y 23）
        unit=176/14.0       # T 闊 176px ≈ 14 格（程序 12 格＋把手圓頭）
        R=int(round(20*unit)); Hh=23+R
        can=Image.new('RGBA',(176,Hh),(0,0,0,0)); can.paste(hu,(0,0),hu)
        rx=176-(239-140)   # 轉 180° 後桿嘅 x
        rod2=im.crop((219,433,239,450)).resize((20,Hh-40),Image.BICUBIC)   # 拉長（唔重複砌，免得一節節）
        can2=Image.new('RGBA',(176,Hh),(0,0,0,0)); can2.paste(rod2,(rx,38),rod2); can2.paste(hu,(0,0),hu); can=can2
        S=max(Hh,176); sq=Image.new('RGBA',(S,S),(0,0,0,0)); sq.paste(can,((S-176)//2,0),can)
        gx=((S-176)//2+rx+10)/S; gy=Hh/S
        sq.resize((256,256),Image.LANCZOS).save(OUT+'/tool_pumph.webp','WEBP',quality=92,method=6)
        szp=(S/unit)/24.0
        out[k]={"key":"tool_pumph","grip":[round(gx,4),round(gy,4)],"tip":[round(gx,4),round(gy-0.5,4)],"sz":round(szp,4),
                "edge":[[round(gx,4),round(gy,4)],[round(gx,4),round(gy,4)],[0,1],nm]}
        # 泵身：去咗 T 柄同桿，轉 180°（泵筒蓋喺頂、喉圈喺底）
        A[431:]=0; body=Image.fromarray(A,'RGBA').rotate(180)
        ab=alpha(body); ys,xs=np.where(ab>20); body=body.crop((xs.min(),ys.min(),xs.max()+1,ys.max()+1))
        cx=(512-228)-xs.min()   # 泵筒中線
        W=max(cx,body.width-cx)*2; bb=Image.new('RGBA',(W,body.height),(0,0,0,0)); bb.paste(body,(W//2-cx,0),body)
        s=256/max(bb.size); bb=bb.resize((max(1,round(bb.width*s)),max(1,round(bb.height*s))),Image.LANCZOS)
        bb.save(OUT+'/tool_pump_body.webp','WEBP',quality=92,method=6); print('pump body',bb.size)
        print(k,out[k]); continue
    if k in ('needle','screwdriver','pestle','shaker'):
        t,bt=ends(im)
        if k=='shaker': t,bt=(0.63,0.15),(0.38,0.90)
        if k=='pestle': t,bt=(0.55,0.065),(0.39,0.945)
        if k=='needle': bt=(0.408,0.85)
        U=nz((t[0]-bt[0],t[1]-bt[1])); n=U
        if k in ('needle','screwdriver'):
            a=b=t; sz=(1.0)/(math.hypot(t[0]-bt[0],t[1]-bt[1]))*(1.0 if k=='needle' else 0.98)
        else:
            perp=np.array([-U[1],U[0]]); w={'pestle':0.09,'shaker':0.095}[k]
            a=tuple(np.array(t)-perp*w); b=tuple(np.array(t)+perp*w)
    if k=='cup':   # 翻咗之後量：杯口橢圓長軸（頂 → 底）
        a=(1-0.79,0.07); b=(1-0.875,0.73); n=(-0.991,-0.133); U=n
        a,b=b,a    # b＝杯口領先嗰邊（倒茶 e=1.0）＝工具框 +x
    if k=='saw':
        d=np.array(b)-np.array(a); n=(d[1],-d[0])
    if k=='fork' or k=='pbrush': U=n
    G,Tp,(ta,tb,tn)=solve(a,b,n,U,sz,EDGE[k])
    print('%-11s G(%.3f,%.3f) sz %.2f  工作面工具框 a(%.1f,%.1f) b(%.1f,%.1f) n(%.2f,%.2f)  程序 %s'%(k,G[0],G[1],sz,ta[0],ta[1],tb[0],tb[1],tn[0],tn[1],EDGE[k]))
    im.resize((256,256),Image.LANCZOS).save(OUT+'/tool_%s.webp'%k,'WEBP',quality=92,method=6)
    nn=nz(n)
    out[k]={"key":"tool_"+k,"grip":[round(G[0],4),round(G[1],4)],"tip":[round(Tp[0],4),round(Tp[1],4)],"sz":round(sz,4),
            "edge":[[round(a[0],4),round(a[1],4)],[round(b[0],4),round(b[1],4)],[round(nn[0],4),round(nn[1],4)],nm]}
json.dump(out,open('/home/claude/art/p45/tool_art.json','w'),ensure_ascii=False,indent=1)
