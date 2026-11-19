# -*- coding: utf-8 -*-
# [unify] 由新背景（bgm<圖>_a／_b，縮 390 闊直向疊 a＋b＋b、接縫 60）自動搵彎泥路中線 → tools/unify_roads.json（outpost_layout.py 讀）。
# 方法：每 10px 一行，搵比兩邊光嘅一條 36px 帶，再用動態規劃揀最順嘅路。
import numpy as np, json, sys
from PIL import Image, ImageDraw, ImageFilter
import os
ROOT=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SP=os.path.join(ROOT,"assets","spr")+"/"
OUTJ_P=os.path.join(ROOT,"tools","unify_roads.json")
def stack(i):
    a=Image.open(SP+f'bgm{i}_a.webp').convert('RGB').resize((390,585)); b=Image.open(SP+f'bgm{i}_b.webp').convert('RGB').resize((390,585))
    im=Image.new('RGB',(390,1635)); im.paste(a,(0,0)); im.paste(b.crop((0,60,390,585)),(0,585)); im.paste(b.crop((0,60,390,585)),(0,1110))   # [unify] a＋b＋b（b 重複一次，拉長大排檔區）
    return im
out={}
for i in range(6):
    im=stack(i); g=np.asarray(im.filter(ImageFilter.GaussianBlur(6))).astype(float)
    # road = warm, light: r high
    lum=g[...,0]*0.6+g[...,1]*0.3+g[...,2]*0.1
    ys=list(range(160,1635,10))
    # DP over x positions (step 5) per row
    xs=np.arange(60,331,5)
    # band score: mean lum over width 36
    sc=[]
    for y in ys:
        row=lum[y]
        s=[row[max(0,x-18):x+18].mean() - 0.5*(row[max(0,x-60):max(1,x-30)].mean()+row[x+30:x+60].mean()) for x in xs]
        sc.append(np.array(s))
    n=len(ys); m=len(xs); best=np.zeros((n,m)); prv=np.zeros((n,m),int)
    best[0]=sc[0]
    for k in range(1,n):
        for j in range(m):
            lo=max(0,j-3); hi=min(m,j+4)
            cand=best[k-1][lo:hi]-np.abs(np.arange(lo,hi)-j)*1.5
            a=int(np.argmax(cand)); best[k][j]=cand[a]+sc[k][j]; prv[k][j]=lo+a
    j=int(np.argmax(best[-1])); path=[]
    for k in range(n-1,-1,-1):
        path.append([int(xs[j]),ys[k]]); j=prv[k][j]
    path.reverse()
    out[i]=path


json.dump(out,open(OUTJ_P,'w'))
