# v7：全套介面換成「黑暗系蠟筆」美術（由 patch_v5.py 最尾引用；喺 v6 之後先打）
#  - crBtn / crPanel / crBar / crText / crFill：深色紙底＋預生成蠟筆筆觸（抖動多重描邊、斜線排線、紙紋噪點），offscreen canvas 快取
#  - btn()、HUD（天光、時辰、警覺、怕意、故事、+/-、細地圖、鬼頭像、各掣、提示字）、揀樓、揀卡、故事、結算、搖桿、對白泡、浮字全部換用
#  - 按鈕觸控範圍（buttons[] 嘅 x/y/w/h）完全唔變；按下只係畫面加粗＋下沉 2px
#  - port_tower.py 嘅 drawTitle 錨點已同步改做「function drawTitle(){ crBg(); crTitleDeco();」；其餘錨點唔改（btn('zin'…)、btn('title'…返主頁…)、sv 判斷、'組屋'+… 等）
import re

LIB = r"""
  // ===================== v7 蠟筆 UI（黑暗系蠟筆）=====================
  // 色盤：暗紅 red、骨白 bone、鏽橙 rust、冷紫 violet、苔綠 moss；ink＝炭黑、paper＝深紫褐紙
  var CR={cache:{}, n:0, M:8, tones:{
    red:   {b:'#2b1012',m:'#7a2522',e:'#c4493c',t:'#f2e3cc',h:'#e07a62'},
    bone:  {b:'#1e1a16',m:'#5c5246',e:'#d8ccb0',t:'#efe5cf',h:'#f4ead2'},
    rust:  {b:'#2a190d',m:'#8c4b1d',e:'#d87e3c',t:'#f6dcb6',h:'#eea060'},
    violet:{b:'#19132a',m:'#4b3b6e',e:'#9c88cc',t:'#e8e0fa',h:'#bfaee8'},
    moss:  {b:'#121a11',m:'#3b5431',e:'#8aac6c',t:'#e4ecd2',h:'#b4d090'},
    ink:   {b:'#18141b',m:'#3c3544',e:'#958a9c',t:'#ebe3d6',h:'#b8aec0'},
    paper: {b:'#141016',m:'#2e2430',e:'#6a5a68',t:'#e9e1d4',h:'#8a7a8c'},
    sheet: {b:'#1a1418',m:'#3a2a34',e:'#cdbf9f',t:'#efe5cf',h:'#e8dcc0'},
    note:  {b:'#d6c9ab',m:'#b3a283',e:'#3a2c28',t:'#2a1e1c',h:'#efe4c8'},
    dawn:  {b:'#1a1418',m:'#3a5230',e:'#d87e3c',t:'#efe5cf',h:'#eea060'}}};
  // 舊亮色 → 主題色（文字用）
  var CRC={'#ffffff':'#efe5cf','#fff3c8':'#efdcb4','#ffd54a':'#e6a85a','#ffcc55':'#e6a85a','#ffe9a0':'#e8d2a0','#ffe9c0':'#efdcb8','#8affc8':'#b2d394','#9fd6bf':'#a9c79a','#9fe0ff':'#a9a0d8',
    '#ff9a9a':'#e48a78','#ffb0b0':'#e48a78','#ffb7a0':'#e8a088','#ff8a5a':'#e0844a','#dddddd':'#ddd2bd','#d8d8d0':'#ddd2bd','#c8ccc4':'#cfc4b0','#ecece6':'#efe5cf','#d6dad2':'#ddd2bd',
    '#e2e6e0':'#efe5cf','#7a7f78':'#9a8e92','#55585a':'#8a7e84','#5a5e58':'#7a6e74','#e8e2d0':'#e6dcc6','#ffd8c8':'#e8c4b0','#ff3a2a':'#d2463a','#d24a3a':'#c4493c'};
  function crCol(c){ if (typeof c!=='string') return c; var k=c.toLowerCase(); if (k==='#fff') k='#ffffff'; return CRC[k]||c; }
  function crRnd(seed){ var s=seed%2147483646+1; return function(){ s=(s*16807)%2147483647; return (s-1)/2147483646; }; }
  function crHash(str){ var h=2166136261; for (var i=0;i<str.length;i++){ h^=str.charCodeAt(i); h=Math.imul(h,16777619); } return (h>>>0)%2147483646+1; }
  // 紙紋噪點（一次生成，repeat）
  function crGrain(){ if (CR.grain) return CR.grain; var c=document.createElement('canvas'); c.width=c.height=128; var x=c.getContext('2d'), r=crRnd(99);
    for (var i=0;i<2600;i++){ var v=r(); x.fillStyle=v<0.55?'rgba(0,0,0,'+(0.10+r()*0.25)+')':'rgba(255,240,220,'+(0.03+r()*0.07)+')'; x.fillRect(r()*128,r()*128,1+r()*1.6,1+r()*1.2); }
    x.strokeStyle='rgba(0,0,0,0.2)'; x.lineWidth=0.7; for (var j=0;j<70;j++){ var px=r()*128, py=r()*128; x.beginPath(); x.moveTo(px,py); x.lineTo(px+4+r()*10,py+(r()-0.5)*3); x.stroke(); } CR.grain=c; return c; }
  function crShape(r,w,h,j,ring){ var P=[];
    if (ring){ var R=w/2, n=Math.max(18,Math.round(R*0.6)); for (var i=0;i<n;i++){ var a=i/n*Math.PI*2; P.push([R+Math.cos(a)*(R+(r()-0.5)*j),R+Math.sin(a)*(R+(r()-0.5)*j)]); } return P; }
    function seg(x0,y0,x1,y1){ var L=Math.hypot(x1-x0,y1-y0), n=Math.max(2,Math.round(L/16)); for (var i=0;i<n;i++){ var t=i/n; P.push([x0+(x1-x0)*t+(r()-0.5)*j, y0+(y1-y0)*t+(r()-0.5)*j]); } }
    seg(0,0,w,0); seg(w,0,w,h); seg(w,h,0,h); seg(0,h,0,0); return P; }
  function crTrace(c,P){ c.beginPath(); c.moveTo(P[0][0],P[0][1]); for (var i=1;i<P.length;i++) c.lineTo(P[i][0],P[i][1]); c.closePath(); }
  // 砌一塊蠟筆底（mode：n 平常、p 按下、off 停用、panel 大紙、bar 槽、fill 進度色、ring 圓）
  function crBuild(w,h,tone,mode){
    var T=CR.tones[tone]||CR.tones.ink, M=CR.M, D=DPR, o=document.createElement('canvas'); o.width=Math.ceil((w+M*2)*D); o.height=Math.ceil((h+M*2)*D);
    var c=o.getContext('2d'); c.scale(D,D); c.translate(M,M);
    var r=crRnd(crHash(w+'x'+h+tone+mode)), pr=mode==='p', off=mode==='off', pan=mode==='panel', bar=mode==='bar'||mode==='fill', ring=mode.indexOf('ring')===0, J=pan?2.4:bar?1:1.7;
    var P=crShape(r,w,h,J,ring);
    if (!pr&&!pan&&!bar){ c.save(); c.translate(2,3); crTrace(c,P); c.fillStyle='rgba(0,0,0,0.55)'; c.fill(); c.restore(); }
    crTrace(c,P);
    if (mode==='fill'&&tone==='dawn'){ var gd=c.createLinearGradient(0,0,w,0); gd.addColorStop(0,'#24361f'); gd.addColorStop(0.62,'#6a2220'); gd.addColorStop(1,'#b8642c'); c.fillStyle=gd; }
    else c.fillStyle=mode==='fill'?T.m:T.b;
    c.fill();
    c.save(); crTrace(c,P); c.clip();
    var g=c.createLinearGradient(0,0,0,h); g.addColorStop(0,'rgba(255,240,220,0.06)'); g.addColorStop(1,'rgba(0,0,0,0.34)'); c.fillStyle=g; c.fillRect(0,0,w,h);
    // 斜線排線
    c.strokeStyle=mode==='fill'?T.h:T.m; c.lineCap='round'; var step=pan?7:bar?3.5:5;
    for (var k=-h-4;k<w+h;k+=step+r()*2){ c.globalAlpha=(pan?0.22:mode==='fill'?0.28:0.36)+r()*0.25; c.lineWidth=0.8+r()*1.4; c.beginPath(); var a0=k+(r()-0.5)*3; c.moveTo(a0,h+2); c.lineTo(a0+h*0.9+(r()-0.5)*4,-2); c.stroke(); }
    // 零碎交叉筆觸
    c.strokeStyle=T.e; var nq=pan?Math.min(260,w*h/900):w/6; for (var q=0;q<nq;q++){ c.globalAlpha=0.05+r()*0.08; c.lineWidth=0.6+r(); var qx=r()*w, qy=r()*h; c.beginPath(); c.moveTo(qx,qy); c.lineTo(qx+6+r()*14,qy-3-r()*5); c.stroke(); }
    c.globalAlpha=1; c.fillStyle=c.createPattern(crGrain(),'repeat'); c.fillRect(-2,-2,w+4,h+4);
    if (!pan&&!bar&&!ring){ c.strokeStyle=T.h; for (var s2=0;s2<3;s2++){ c.globalAlpha=0.08+r()*0.12; c.lineWidth=2+r()*2; c.beginPath(); var yy=3+s2*2.2+r(); c.moveTo(6+r()*6,yy); c.lineTo(w-6-r()*10,yy+(r()-0.5)*2); c.stroke(); } }
    c.restore();
    // 抖動多重描邊
    var passes=pr?4:bar?2:3, jj=pan?2.6:bar?1:2;
    if (mode!=='fill') for (var p=0;p<passes;p++){ var Q=P.map(function(v){ return [v[0]+(r()-0.5)*jj,v[1]+(r()-0.5)*jj]; }); c.globalAlpha=p===0?0.95:0.42+r()*0.3; c.strokeStyle=(p===passes-1&&!bar)?'rgba(0,0,0,0.55)':T.e; c.lineWidth=(pr?3.4:pan?2.1:bar?1.3:2.2)-p*0.35+r()*0.5; c.lineJoin='round'; crTrace(c,Q); c.stroke(); }
    if (!bar&&!ring){ c.fillStyle=T.e; [[0,0],[w,0],[w,h],[0,h]].forEach(function(o2){ c.globalAlpha=0.6; c.beginPath(); c.arc(o2[0]+(r()-0.5)*2,o2[1]+(r()-0.5)*2,1.3+r()*1.2,0,7); c.fill(); }); }
    c.globalAlpha=1;
    if (off){ c.globalCompositeOperation='source-atop'; c.fillStyle='rgba(16,13,18,0.58)'; c.fillRect(-M,-M,w+2*M,h+2*M); c.globalCompositeOperation='source-over'; }
    return o; }
  function crGet(w,h,tone,mode){ w=Math.max(4,Math.round(w)); h=Math.max(4,Math.round(h)); var k=w+'|'+h+'|'+tone+'|'+mode+'|'+DPR, v=CR.cache[k];
    if (!v){ if (CR.n>220){ CR.cache={}; CR.n=0; } v=CR.cache[k]=crBuild(w,h,tone,mode); CR.n++; } return v; }
  function crBlit(c,im,x,y){ var M=CR.M; c.drawImage(im,x-M,y-M,im.width/DPR,im.height/DPR); }
  function crPanel(c,x,y,w,h,tone){ crBlit(c,crGet(w,h,tone||'paper','panel'),x,y); }
  // 字：手寫感陰影（偏移暗影＋暗描邊＋蠟筆重描）
  function crText(c,s,x,y,sz,col,al,mw,mid,wt){ s=String(s); c.save(); c.font=(wt||'bold')+' '+sz+'px '+FONT; c.textAlign=al||'left'; c.textBaseline=mid?'middle':'alphabetic'; c.lineJoin='round';
    var F=function(dx,dy){ if (mw) c.fillText(s,x+dx,y+dy,mw); else c.fillText(s,x+dx,y+dy); };
    c.fillStyle='rgba(6,3,8,0.88)'; F(1.4,2); c.lineWidth=Math.max(2.4,sz*0.2); c.strokeStyle='rgba(8,5,10,0.82)'; if (mw) c.strokeText(s,x,y,mw); else c.strokeText(s,x,y);
    c.fillStyle=crCol(col||'#efe5cf'); F(0,0); c.globalAlpha*=0.35; F(0.6,-0.4); c.restore(); }
  // 用而家 ctx 狀態（font/align/fillStyle）寫字，自動套手寫陰影＋主題色
  function crFill(s,x,y,mw){ var m=/(\d+(?:\.\d+)?)px/.exec(ctx.font), sz=m?+m[1]:13, bold=/bold/.test(ctx.font); crText(ctx,s,x,y,sz,ctx.fillStyle,ctx.textAlign,mw,false,bold?'bold':'normal'); }
  function crBar(c,x,y,w,h,f,tone){ crBlit(c,crGet(w,h,'ink','bar'),x,y); f=Math.max(0,Math.min(1,f||0)); if (f<=0) return; c.save(); c.beginPath(); c.rect(x-2,y-3,w*f+2,h+6); c.clip(); crBlit(c,crGet(w,h,tone||'red','fill'),x,y); c.restore();
    if (f<1){ c.strokeStyle=(CR.tones[tone]||CR.tones.red).e; c.globalAlpha=0.8; c.lineWidth=2; c.beginPath(); c.moveTo(x+w*f,y-1); c.lineTo(x+w*f+1,y+h+1); c.stroke(); c.globalAlpha=1; } }
  function crTone(col){ var k=String(col||'').toLowerCase();
    return ({'#6e1c1c':'red','#5a1c1c':'red','#2a4a7a':'violet','#2f5a4a':'moss','#3a5a2a':'moss','#2e3a34':'moss','#8a5a14':'rust','#3a3a40':'ink','#2c2c33':'ink','#24242a':'ink','#26262c':'ink'})[k]||'ink'; }
  function crBtn(c,x,y,w,h,label,tone,pressed,off){ var dy=pressed?2:0; crBlit(c,crGet(w,h,tone,pressed?'p':off?'off':'n'),x,y+dy);
    if (label) crText(c,label,x+w/2,y+h/2+dy+1,h>=50?17:16,off?'#8a7e84':(CR.tones[tone]||CR.tones.ink).t,'center',w-10,true); }
  function crBubble(x,y,t,col){ ctx.font='bold 12px '+FONT; var w=Math.ceil((Math.min(190,ctx.measureText(t).width+16))/8)*8; crBlit(ctx,crGet(w,22,'note','bar'),x-w/2,y-24);
    ctx.save(); ctx.fillStyle=col||'#2a1e1c'; ctx.textAlign='center'; ctx.fillText(t,x,y-9,w-8); ctx.restore(); }
  function crBg(){ crPanel(ctx,-8,-8,VW+16,VH+16,'paper'); }
  function crPressed(id){ return (ptr&&ptr.btn===id)||(PRESS&&PRESS.id===id&&performance.now()-PRESS.t<200); }
"""

def patch(s):
    def R(a,b,cnt=1):
        nonlocal s
        assert s.count(a)==cnt,('v7 錨點',a[:90],s.count(a)); s=s.replace(a,b)
    # ---------- 函數庫 + btn() ----------
    i=s.index("  function btn(id,x,y,w,h,label,col,on){"); j=s.index("\n",i)
    s=s[:i]+LIB+"  function btn(id,x,y,w,h,label,col,on){ buttons.push({id:id,x:x,y:y,w:w,h:h}); crBtn(ctx,x,y,w,h,label,crTone(col),crPressed(id),on===false); }"+s[j:]
    # 對白泡、txt、浮字
    i=s.index("  function bubble(x,y,t,col){"); j=s.index("\n",i)
    s=s[:i]+"  function bubble(x,y,t,col){ crBubble(x,y,t,col); }"+s[j:]
    R("function txt(s,x,y,c,sz){ ctx.font='bold '+(sz||12)+'px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(s,x,y); ctx.fillStyle=c; ctx.fillText(s,x,y); }",
      "function txt(s,x,y,c,sz){ crText(ctx,s,x,y,sz||12,c,'center'); }")
    R("G.floats.forEach(function(f){ ctx.globalAlpha=Math.min(1,f.life); ctx.font='bold 13px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#0a0a0c'; ctx.strokeText(f.t,f.x,f.y); ctx.fillStyle=f.c; ctx.fillText(f.t,f.x,f.y); ctx.globalAlpha=1; });",
      "G.floats.forEach(function(f){ ctx.globalAlpha=Math.min(1,f.life); crText(ctx,f.t,f.x,f.y,14,f.c,'center'); ctx.globalAlpha=1; });")
    # 住戶怕意條
    R("if (r.state==='home'&&r.fear>0){ ctx.fillStyle='#1a1a1e'; ctx.fillRect(r.x-18,r.y-RH-6,36,6); ctx.fillStyle='#d24a3a'; ctx.fillRect(r.x-18,r.y-RH-6,36*r.fear/100,6); }",
      "if (r.state==='home'&&r.fear>0){ crBar(ctx,r.x-20,r.y-RH-8,40,7,r.fear/100,'red'); }")
    # ---------- 細地圖 ----------
    R("ctx.fillStyle='rgba(8,8,12,0.78)'; ctx.fillRect(mx-2,my-2,mw+4,mh+4); ctx.strokeStyle='#4a4a50'; ctx.lineWidth=1; ctx.strokeRect(mx-2,my-2,mw+4,mh+4);",
      "crPanel(ctx,mx-5,my-5,mw+10,mh+10,'ink');")
    R("ctx.fillStyle=u.ot==='deity'?'#5a2a20':!u.open?'#2a2a30':(u.seen||u.entered)?'#3a4a44':'#1a1a1e';","ctx.fillStyle=u.ot==='deity'?'#5a2420':!u.open?'#2a2430':(u.seen||u.entered)?'#3a4632':'#1c1820';")
    R("ctx.fillStyle='#3fbf8f'; ['f0_e',","ctx.fillStyle='#8aac6c'; ['f0_e',")
    R("ctx.fillStyle=h.kind==='collector'?'#ffd54a':h.state==='chase'?'#ff3a2a':'#d08070';","ctx.fillStyle=h.kind==='collector'?'#d87e3c':h.state==='chase'?'#e0483a':'#b8786a';")
    R("ctx.fillStyle=i===G.active?'#8affc8':'#3a9a78'; ctx.beginPath(); ctx.arc(mx+g.x*sx","ctx.fillStyle=i===G.active?'#efe5cf':'#9c88cc'; ctx.beginPath(); ctx.arc(mx+g.x*sx")
    R("ctx.strokeStyle='rgba(255,255,255,0.5)'; ctx.strokeRect(mx+cam.x*sx","ctx.strokeStyle='rgba(216,204,176,0.6)'; ctx.lineWidth=1.2; ctx.strokeRect(mx+cam.x*sx")
    # ---------- HUD ----------
    i=s.index("  function drawHUD(){"); j=s.index("  function wrap(t,x,y,w,lh){")
    s=s[:i]+r"""  function drawHUD(){
    // 頂：時辰 + 天光進度 + 警覺 + 怕意
    crPanel(ctx,-8,-8,VW+16,TOP+8,'paper');
    var fr=Math.min(1,G.t/(PHT*3));
    crBar(ctx,12,8,VW-24,15,fr,'dawn');
    crText(ctx,(G.gate?'陰門死守 '+Math.ceil(30-G.gate.t)+' 秒　':'')+(G.phase<3?PH[G.phase]+'　天光 '+Math.floor(fr*100)+'%':'天光後・追兵第 '+G.wave+' 輪')+'　警覺 '+G.alert,14,44,15,G.alert>=3?'#e8b4a0':'#efe5cf','left',VW-110);
    crText(ctx,'怕意 '+G.fear,VW-14,44,15,'#b2d394','right');
    crText(ctx,'收穫 '+G.bag.length+'/'+BAGMAX+'　紙人 '+G.dolls+'/6　匙 紅'+(G.keys.key||0)+' 黃'+(G.keys.key2||0)+(G.carry?'　帶住失物':''),14,68,13,'#cfc4b0','left',VW-118);
    btn('story',VW-100,48,90,44,'故事 '+G.story.length+'/'+STORY.length,'#2e3a34'); drawMini(); if (cam.free) btn('follow',VW/2-66,TOP+8,132,46,'◎ 跟返隻鬼','#2f5a4a');
    btn('zin',VW-56,TOP+8,46,46,'＋','#24242a'); btn('zout',VW-56,TOP+60,46,46,'－','#24242a');
    // 底：鬼頭像 + 按鈕
    var y0=VH-BOT; crPanel(ctx,-8,y0,VW+16,BOT+8,'paper');
    if (G.toastT>0&&G.toast){ crPanel(ctx,10,y0-58,VW-20,52,'sheet'); ctx.fillStyle='#efdcb4'; ctx.font='bold 13px '+FONT; ctx.textAlign='left'; wrap(G.toast,20,y0-37,VW-40,17); }
    G.gh.forEach(function(o,i){ var x=10+i*72, y=y0+12, full=o.energy>=100&&!o.home, act=i===G.active; buttons.push({id:'gh'+i,x:x,y:y,w:64,h:74}); var pz=crPressed('gh'+i), dy=pz?2:0;
      if (full){ ctx.save(); ctx.globalAlpha=0.45+0.35*Math.sin(G.t*8); crBlit(ctx,crGet(72,82,'rust','panel'),x-4,y-4+dy); ctx.restore(); }
      crBlit(ctx,crGet(64,74,full?'rust':act?'moss':'ink',pz?'p':'n'),x,y+dy);
      sprite(o.d.sprite,x+32,y+58+dy,46,false,o.home||o.out?0.3:1);
      crBar(ctx,x+6,y+5+dy,52,6,o.energy/100,full?'rust':'red');
      if (full) crText(ctx,'點我放大招',x+32,y+24+dy,11,'#f6dcb6','center',60);
      crText(ctx,o.out?'被收服':o.home?'已返':o.d.name+(o.caught?' '+o.caught+'/3':''),x+32,y+69+dy,12,act?'#e4ecd2':'#ebe3d6','center',60); });
    var g=G.gh[G.active], n=G.nodes[g.node], atP=!g.to&&n.kind==='portal'&&!g.home;
    btn('scare',VW-170,y0+12,74,52,'嚇！','#6e1c1c');
    btn('inv',VW-88,y0+12,76,52,g.invCd>0?'隱身 '+Math.ceil(g.invCd):'隱身','#2a4a7a',g.invCd<=0);
    var A=ctxAction(g), U=g.energy>=100&&!g.home&&!g.out&&!G.ult, aw=U?(VW-30)/2:VW-20; if (A) btn('act',10,y0+92,aw,46,A.t,A.k==='respect'?'#3a3a40':'#3a5a2a',A.k!=='respect'); else if (!U){ crText(ctx,'撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口出「互動」',VW/2,y0+120,12,'#9a8e92','center',VW-20,false,'normal'); }
    if (U) btn('ult',A?20+aw:10,y0+92,A?aw:VW-20,46,'放大招：'+ULT[g.d.key].n,'#8a5a14');
    var hw=(VW-30)/2; btn('gate',10,y0+146,hw,44,G.gate?'陰門 '+Math.ceil(30-G.gate.t)+'s':atP?'開陰門（企定）':'陰門：天台/地庫','#2f5a4a',atP&&!G.gate); btn('doll',20+hw,y0+146,hw,44,'替身遁走 '+G.dolls+'/6','#5a1c1c',G.dolls>=6&&!G.gate);
    crText(ctx,'拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅',VW/2,VH-12,12,'#9a8e92','center',VW-16,false,'normal');
    if (G.choice) drawChoice(); if (G.showStory) drawStory(); if (G.over) drawOver();
  }
"""+s[j:]
    # wrap：每行套手寫陰影＋主題色
    R("function wrap(t,x,y,w,lh){ var line='',yy=y; for (var i=0;i<t.length;i++){ var tt=line+t[i]; if (ctx.measureText(tt).width>w){ ctx.fillText(line,x,yy); line=t[i]; yy+=lh; } else line=tt; } ctx.fillText(line,x,yy); return yy; }",
      "function wrap(t,x,y,w,lh){ var line='',yy=y; for (var i=0;i<t.length;i++){ var tt=line+t[i]; if (ctx.measureText(tt).width>w){ crFill(line,x,yy); line=t[i]; yy+=lh; } else line=tt; } crFill(line,x,yy); return yy; }")
    # ---------- 彈出面板 ----------
    R("function panel(h){ ctx.fillStyle='rgba(4,4,6,0.75)'; ctx.fillRect(0,0,VW,VH); var y=(VH-h)/2; ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(16,y,VW-32,h,16); ctx.fill(); ctx.stroke(); buttons=[]; return y; }",
      "function panel(h){ ctx.fillStyle='rgba(6,3,8,0.78)'; ctx.fillRect(0,0,VW,VH); var y=(VH-h)/2; crPanel(ctx,16,y,VW-32,h,'sheet'); buttons=[]; return y; }")
    R("ctx.fillStyle='rgba(4,4,6,0.35)'; ctx.fillRect(0,0,VW,VH); ctx.fillStyle='#17171b'; ctx.strokeStyle='#9fd6bf'; ctx.lineWidth=2; rr(10,y,VW-20,h,16); ctx.fill(); ctx.stroke(); buttons=[];",
      "ctx.fillStyle='rgba(6,3,8,0.45)'; ctx.fillRect(0,0,VW,VH); crPanel(ctx,10,y,VW-20,h,'sheet'); buttons=[];")
    # 揀卡、故事、結算、揀樓：所有 ctx.fillText → crFill（手寫陰影＋主題色）
    for a,b in [("  function drawChoice(){","  function drawStory(){"),("  function drawStory(){","  function drawOver(){"),("  function drawOver(){","  function drawTitle(){"),("  function drawTitle(){","  // ---------- 輸入 ----------")]:
        i=s.index(a); j=s.index(b,i); s=s[:i]+s[i:j].replace("ctx.fillText(","crFill(")+s[j:]
    R("crFill(c.t,VW/2,by+32); ctx.fillStyle='#d6dad2'; ctx.font='14px '+FONT; crFill(c.d,VW/2,by+58);",
      "crFill(c.t,VW/2,by+32,VW-70); ctx.fillStyle='#d6dad2'; ctx.font='bold 14px '+FONT; crFill(c.d,VW/2,by+58,VW-70);")
    R("ctx.textAlign='left'; ctx.font='12px '+FONT; var yy=y+60;","ctx.textAlign='left'; ctx.font='13px '+FONT; var yy=y+60;")
    # 揀樓畫面：保留 port 錨點（開頭兩句），之後鋪紙底
    R("function drawTitle(){ ctx.fillStyle='#0e0e11'; ctx.fillRect(0,0,VW,VH); ctx.textAlign='center'; ctx.fillStyle='#e2e6e0'; ctx.font='bold 34px '+FONT;",
      "function drawTitle(){ crBg(); crTitleDeco(); ctx.textAlign='center'; ctx.fillStyle='#c4493c'; ctx.font='bold 40px '+FONT;")
    R("ctx.font='16px '+FONT; ctx.fillStyle='#9fd6bf'; crFill('揀一棟樓・天光前返陰間',VW/2,VH*0.24+34);",
      "ctx.font='bold 16px '+FONT; ctx.fillStyle='#d8ccb0'; crFill('揀一棟樓・天光前返陰間',VW/2,VH*0.24+36);")
    R("ctx.fillStyle='#c8ccc4'; ctx.font='14px '+FONT; ['三隻鬼","ctx.fillStyle='#c8ccc4'; ctx.font='bold 14px '+FONT; ['三隻鬼")
    R("ctx.fillStyle='#7a7f78'; ctx.font='12px '+FONT; ctx.textAlign='center'; crFill(shopOpen?","ctx.fillStyle='#7a7f78'; ctx.font='bold 13px '+FONT; ctx.textAlign='center'; crFill(shopOpen?")
    R("  function drawTitle(){","""  function crTitleDeco(){ var r=crRnd(5), y=VH*0.24+52; ctx.save(); ctx.strokeStyle='#7a2522'; ctx.lineCap='round';
    for (var p=0;p<3;p++){ ctx.globalAlpha=0.5+r()*0.4; ctx.lineWidth=2.4-p*0.5; ctx.beginPath(); ctx.moveTo(VW*0.2+r()*6,y+r()*3); for (var k=1;k<=8;k++) ctx.lineTo(VW*0.2+VW*0.6*k/8,y+(r()-0.5)*4); ctx.stroke(); }
    ctx.restore(); crPanel(ctx,14,VH*0.62-24,VW-28,5*24+14,'ink'); }
  function drawTitle(){""")
    # 結算：結果字唔用亮色
    R("ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 24px '+FONT;","ctx.fillStyle=o.ok?'#8affc8':'#ff9a9a'; ctx.font='bold 26px '+FONT;")
    R("ctx.fillStyle='#fff'; ctx.font='15px '+FONT;\n    var msg=","ctx.fillStyle='#fff'; ctx.font='bold 15px '+FONT;\n    var msg=")
    R("if (o.story===STORY.length){ ctx.fillStyle='#ffd54a'; ctx.font='13px '+FONT;","if (o.story===STORY.length){ ctx.fillStyle='#ffd54a'; ctx.font='bold 13px '+FONT;")
    # ---------- 搖桿 ----------
    R("function drawJoy(){ if (!joy||!joy.on) return; var v=joyVec(); ctx.setTransform(DPR,0,0,DPR,0,0); ctx.fillStyle='rgba(10,10,12,0.5)'; ctx.strokeStyle='rgba(170,200,185,0.55)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(joy.ox,joy.oy,JR,0,7); ctx.fill(); ctx.stroke(); ctx.fillStyle='rgba(138,255,200,0.85)'; ctx.beginPath(); ctx.arc(joy.ox+v.x*JR,joy.oy+v.y*JR,24,0,7); ctx.fill(); }",
      "function drawJoy(){ if (!joy||!joy.on) return; var v=joyVec(); ctx.setTransform(DPR,0,0,DPR,0,0); ctx.save(); ctx.globalAlpha=0.7; crBlit(ctx,crGet(JR*2,JR*2,'paper','ring'),joy.ox-JR,joy.oy-JR); ctx.globalAlpha=0.92; crBlit(ctx,crGet(48,48,'bone','ring2'),joy.ox+v.x*JR-24,joy.oy+v.y*JR-24); ctx.restore(); }")
    return s

if __name__=='__main__':
    print('patch_v7_ui：由 patch_v5.py 引用')
