# patch_v11_gp：由 patch_v5.py 引用；def patch(s) 收 pangsa.js 字串、回傳改好嘅字串
# 老闆要求：「村里鬼的能力和各个玩法鬼的能力要关联。在村庄里升级后的鬼，在其他模式时，能力也会提升。
#           所以大家在其他模式出现打不过的情况时，就必须好好的回村里升级自己家的鬼。我希望整个生态系统是完善的。」
#  1. 三隻鬼開局讀 window.GP.kindMul(村入面同種)：g.mul / g.pow / g.trainee（未招募＝見習 0.7）
#     嚇人量 ×mul（scareRes、屋內被動、附身、入屋作怪）；大招時長 ×(0.85+0.15mul)；能量累積 ×(0.8+0.2mul)；
#     移動 ×min(1.12,0.92+0.08mul)；隱身時間 ×(0.85+0.15mul)、冷卻 9 秒部分 ×(1.15-0.15mul)；讀條 ×min(1.3,0.9+0.1mul)
#     mul=1 時全部因子 =1（同改之前一模一樣）。冇 GP（lyg 獨立版）＝1.0、冇難度加成。
#  2. 樓力：每棟樓每贏一晚 +1 級（最多 8）；建議鬼力 = 基數(組屋 1100／老店屋 1500)×(1+0.18×級)；
#     住客受驚 ÷ (1+0.18×級)^0.6（同 GP 鬼力→倍率嘅 0.6 次方一致）、加派保安間隔 ÷(1+0.06×級)；第 0 級＝改之前一樣
#  3. 介面：HUD 頭像鬼力／見習、揀樓畫面建議鬼力（唔夠紅字）、失敗結算「返村升級」
# 全部 hook 用 // GP HOOK 標明；錨點唔見／唔唯一會 assert 報錯。

JS = r"""
  // ===== GP HOOK（tools/patch_v11_gp.py）：村入面嘅鬼力 → 樓裡有鬼三隻鬼嘅能力 =====
  var GP_TRAINEE_POW=250, GP_BASE={flat:1100, shop:1500}, GP_TIER_MAX=8;
  var GP_TRAINEE_MSG='村入面未有呢隻鬼，只係見習水平。返村招募／升級先會變強！';
  function gpRead(d){ var P=window.GP; if (!P||!d.gpk) return {mul:1,pow:0,tr:false,na:true};
    try{ var pw=P.kindPow(d.gpk)||0, m=P.kindMul(d.gpk); if (!isFinite(m)||m<=0) m=1; return {mul:m,pow:pw,tr:pw<=0,na:false}; }catch(e){ return {mul:1,pow:0,tr:false,na:true}; } }
  function gpApply(g){ var r=gpRead(g.d), m=r.mul; g.mul=m; g.pow=r.pow; g.trainee=r.tr; g.gpNA=r.na;
    g.spm=Math.min(1.12,1+0.08*(m-1));                         // 移動（封頂 +12%，唔好快過保安太多）
    g.em=1+0.2*(m-1);                                            // 能量累積
    g.tm=Math.min(1.3,1+0.1*(m-1));                              // 讀條（搜嘢）
    g.im=Math.max(0.85,Math.min(1.35,1+0.15*(m-1)));            // 隱身時間
    g.icd=Math.max(0.7,Math.min(1.1,1-0.15*(m-1)));             // 隱身冷卻（9 秒嗰部分）
    g.um=Math.max(0.9,Math.min(1.3,1+0.15*(m-1)));              // 大招控場時長
    g._eL=g.energy||0; }
  function gpSv(){ try{ return JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); }catch(e){ return {}; } }
  function gpSvPut(sv){ try{ localStorage.setItem('lyg_pangsa',JSON.stringify(sv)); }catch(e){} }
  function gpTier(lv){ if (!window.GP) return 0; var sv=gpSv()||{}; return Math.min(GP_TIER_MAX,+(sv['win_'+lv]||0)); }
  function gpNeed(lv){ return Math.round((GP_BASE[lv]||1100)*(1+0.18*gpTier(lv))/10)*10; }
  function gpDiff(lv){ return Math.pow(1+0.18*gpTier(lv),0.6); }
  function gpPowOf(d){ var r=gpRead(d); return r.na?0:r.tr?GP_TRAINEE_POW:r.pow; }
  function gpTeam(){ return GH.reduce(function(s,d){ return s+gpPowOf(d); },0); }
  // 住客受驚倍率：鬼嘅 mul ÷ 樓力難度（冇鬼／陷阱自己嚇＝1）
  function gpF(g){ return ((g&&g.mul)||1)/((G&&G.gpD)||1); }
  // 能量：每幀將「增加咗嘅部分」乘 em（所有來源，包括入屋模式、𨋢、支線）
  function gpE(g){ var e=g.energy||0, L=g._eL; if (L!=null&&e>L&&g.em&&g.em!==1) g.energy=Math.min(100,L+(e-L)*g.em); g._eL=g.energy; }
  function gpStart(){ G.gh.forEach(gpApply); G.gpHas=!!window.GP; G.gpTier=gpTier(curLv); G.gpD=gpDiff(curLv); G.gpNeed=gpNeed(curLv); G.gpTeam=gpTeam();
    G.gpMsg=G.gpHas?('今晚'+LV.name+'第 '+(G.gpTier+1)+' 級：建議鬼力 '+G.gpNeed+'，我哋三隻合共 '+G.gpTeam+(G.gpTeam<G.gpNeed?'——唔夠喎，小心啲！打唔過就返村升級。':'，夠晒膽！')+(G.gh.some(function(g){return g.trainee;})?'（有見習鬼）':'')):null; }
  function gpTick(){ if (G.gpMsg&&G.t>=5.6){ toast(G.gpMsg); G.gpMsg=null; } }
  function gpOnEnd(why){ var o=G.over; o.gpHas=!!G.gpHas; o.gpNeed=G.gpNeed; o.gpTeam=G.gpTeam; o.gpTier=G.gpTier;
    if (why!=='fail'&&G.gpHas){ var sv=gpSv()||{}; sv['win_'+curLv]=(+(sv['win_'+curLv]||0))+1; gpSvPut(sv); o.gpUp=gpTier(curLv)>G.gpTier; } }
  function gpGoVillage(){ scene='title'; }
  function gpPill(x,y,w,t,bg,fg){ ctx.save(); ctx.fillStyle=bg; ctx.strokeStyle='rgba(0,0,0,0.55)'; ctx.lineWidth=1.5; ctx.beginPath(); if (ctx.roundRect) ctx.roundRect(x,y,w,16,8); else ctx.rect(x,y,w,16); ctx.fill(); ctx.stroke(); ctx.restore(); crText(ctx,t,x+w/2,y+12.5,11,fg,'center',w-4); }
  function gpBadge(o,x,y){ if (!G.gpHas) return; if (o.trainee) gpPill(x+8,y-12,48,'見習','#7a2522','#ffd9c8'); else gpPill(x+2,y-12,60,'鬼力 '+o.pow,'#26331f','#d8f0b8'); }
  function gpTitle(){ if (!window.GP) return; var team=gpTeam();
    GH.forEach(function(d,i){ var r=gpRead(d), cx=VW/2+(i-1)*100; crText(ctx,r.tr?'見習（未招募）':'鬼力 '+r.pow,cx,VH*0.52+18,13,r.tr?'#ff8a72':'#c8e6a8','center',96); });
    crText(ctx,'三隻合共鬼力 '+team,VW/2,VH*0.52+40,15,'#efe5cf','center',VW-30);
    ['flat','shop'].forEach(function(lv,i){ var need=gpNeed(lv), cx=i?34+(VW-56)/2+(VW-56)/4:22+(VW-56)/4, ok=team>=need;
      crText(ctx,'建議鬼力 '+need+(ok?'':'（唔夠）'),cx,VH*0.80+76,13,ok?'#b2d394':'#ff6a5a','center',(VW-56)/2); }); }
  function gpOver(o,y){ if (!o.gpHas) return; var ok=o.gpTeam>=o.gpNeed;
    ctx.textAlign='center'; ctx.fillStyle=ok?'#d8f0b8':'#ff7a64'; ctx.font='bold 16px '+FONT; crFill('你嘅鬼力 '+o.gpTeam+'／建議 '+o.gpNeed,VW/2,y+204,VW-50);
    ctx.fillStyle='#efdcb4'; ctx.font='bold 13px '+FONT; ctx.textAlign='left'; var tx=window.GP&&GP.hint?GP.hint(ok?0:o.gpNeed):''; wrap(tx,36,y+230,VW-72,18); ctx.textAlign='center';
    btn('toVillage',VW/2-125,y+268,250,44,'返村升級','#8a5a14'); }
"""

def patch(s):
    if 'GP HOOK' in s: return s
    def R(a,b):
        nonlocal s
        assert s.count(a)==1,(a[:80],s.count(a)); s=s.replace(a,b)
    # 0. 三隻鬼對應村入面嘅種類
    R("{key:'eking', name:'餓鬼',","{key:'eking', gpk:'eguiking', name:'餓鬼',")
    R("{key:'toyol', name:'Toyol',","{key:'toyol', gpk:'toyol', name:'Toyol',")
    R("{key:'tianhua', name:'天花姐',","{key:'tianhua', gpk:'tianhua', name:'天花姐',")
    # 1. 函數區
    R("\n  // ---------- 遊戲狀態 ----------\n", JS+"\n  // ---------- 遊戲狀態 ----------\n")
    # 2. 開局讀鬼力
    R("G.gh.forEach(function(g){ var n=G.nodes[g.node]; g.x=n.x; g.y=n.y; });","G.gh.forEach(function(g){ var n=G.nodes[g.node]; g.x=n.x; g.y=n.y; }); gpStart();   // GP HOOK")
    R("G.toastT-=dt; if (!G.traces)","G.toastT-=dt; gpTick(); if (!G.traces)")
    # 3. 能量（每幀）、移動、讀條、屋內被動嚇
    R("G.gh.forEach(function(g){ if (g.home||g.out) return;\n      g.blockT=","G.gh.forEach(function(g){ gpE(g); if (g.home||g.out) return;\n      g.blockT=")
    R("var sp=g.d.sp*G.mods.spd;","var sp=g.d.sp*G.mods.spd*(g.spm||1);")
    R("g.p+=g.d.sp*G.mods.spd*dt/D;","g.p+=g.d.sp*G.mods.spd*(g.spm||1)*dt/D;")
    R("g.taskP+=dt*G.mods.task/ITEM[it].t;","g.taskP+=dt*G.mods.task*(g.tm||1)/ITEM[it].t;")
    R("un.res.fear+=dt*3*G.mods.pow;","un.res.fear+=dt*3*G.mods.pow*gpF(g);")
    # 4. 嚇人量
    R("r.fear+=amt*G.mods.pow*(1-r.brave); if (r.unit&&r.unit.rs) r.unit.rs.forEach(function(o){ if (o!==r&&o.state==='home'){ o.awake=true; o.woke=true; o.fear+=amt*0.35*(1-o.brave);",
      "r.fear+=amt*G.mods.pow*gpF(g)*(1-r.brave); if (r.unit&&r.unit.rs) r.unit.rs.forEach(function(o){ if (o!==r&&o.state==='home'){ o.awake=true; o.woke=true; o.fear+=amt*0.35*gpF(g)*(1-o.brave);")
    R("r.fear+=P.f*0.6*G.mods.pow*(1-r.brave);","r.fear+=P.f*0.6*G.mods.pow*gpF(g)*(1-r.brave);")
    # 4b. 樓力：加派保安間隔 ÷(1+0.06×級)（第 0 級不變）
    R("G.waveT=G.phase>=3?18:30;","G.waveT=(G.phase>=3?18:30)/(1+0.06*(G.gpTier||0));")
    # 5. 大招控場時長
    R("if (k==='eking'){ G.dark[f]=3.2;","if (k==='eking'){ G.dark[f]=3.2*(g.um||1);")
    R("hs.forEach(function(h){ h.wait=3; }); }","hs.forEach(function(h){ h.wait=3*(g.um||1); }); }")
    R("rs.forEach(function(r){ r.tangle=3.2; scareRes(r,105,g); }); hs.forEach(function(h){ h.wait=3.2; h.to=null; });",
      "rs.forEach(function(r){ r.tangle=3.2*(g.um||1); scareRes(r,105,g); }); hs.forEach(function(h){ h.wait=3.2*(g.um||1); h.to=null; });")
    # 6. 隱身
    R("g.inv=G.mods.inv; g.invCd=G.mods.inv+9;","g.inv=G.mods.inv*(g.im||1); g.invCd=g.inv+9*(g.icd||1);")
    # 7. 揀見習鬼 toast
    R("G.active=i; toast(GH[i].tip+(G.gh[i].energy>=100?'（能量滿！再點頭像放大招）':'')); return; }",
      "G.active=i; toast(G.gh[i].trainee?GP_TRAINEE_MSG:GH[i].tip+(G.gh[i].energy>=100?'（能量滿！再點頭像放大招）':'')); return; }")
    # 8. HUD 頭像鬼力
    R("crText(ctx,o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+69+dy,12,act?'#e4ecd2':'#ebe3d6','center',60); });",
      "crText(ctx,o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+69+dy,12,act?'#e4ecd2':'#ebe3d6','center',60); gpBadge(o,x,y+dy); });")
    # 9. 揀樓畫面：建議鬼力
    R("crFill(shopOpen?'揀一棟樓開始今晚':'組屋過關（安全返陰間）就解鎖老店屋',VW/2,VH*0.80+78); }",
      "crFill(shopOpen?'揀一棟樓開始今晚':'組屋過關（安全返陰間）就解鎖老店屋',VW/2,VH*0.80+(window.GP?100:78)); gpTitle(); }")
    # 10. 結算
    R("    try{ var sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); sv.nights","    gpOnEnd(why);   // GP HOOK\n    try{ var sv=JSON.parse(localStorage.getItem('lyg_pangsa')||'{}'); sv.nights")
    R("    btn('again',VW/2-130,y+420-60,120,44,'再嚟一晚','#5a1c1c');","    if (!o.ok) gpOver(o,y);\n    btn('again',VW/2-130,y+420-60,120,44,'再嚟一晚','#5a1c1c');")
    R("if (id==='again'){ newGame(); bake(); return; }","if (id==='again'){ newGame(); bake(); return; } if (id==='toVillage'){ gpGoVillage(); return; }")
    # 11. 入屋模組要用 gpF
    R("scareRes:scareRes, takeItem:takeItem,","scareRes:scareRes, gpF:gpF, takeItem:takeItem,")
    # 12. 測試介面
    R("window.TW={safe:","window.TW={gp:function(){ return G&&{has:G.gpHas,need:G.gpNeed,team:G.gpTeam,D:G.gpD,tier:G.gpTier,gh:G.gh.map(function(g){ return {k:g.d.key,mul:g.mul,pow:g.pow,trainee:g.trainee,spm:g.spm,em:g.em,tm:g.tm,im:g.im,icd:g.icd,um:g.um}; })}; }, gpRe:function(){ gpStart(); }, gpF:function(i){ return gpF(G.gh[i]); }, end:function(w){ endNight(w); }, sr:function(r,amt,i){ scareRes(r,amt,i==null?null:G.gh[i]); }, ng:function(sd,lv){ newGame(sd,lv); bake(); }, safe:")
    return s
