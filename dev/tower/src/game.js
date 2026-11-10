// 楼里有鬼 M1 — 画面 / 操作层
(function(){
  var S = LYG_SIM, GEO = S.GEO, GR = S.GR, DATA = LYG_DATA;
  var FONT = '"PingFang SC","Noto Sans CJK SC","Noto Sans SC","Microsoft YaHei","Hiragino Sans GB",sans-serif';
  var C = {
    ink:'#140d22', sky0:'#120a26', sky1:'#2b1a4a', facade:'#3b3052', facadeD:'#2e2542',
    wallL:'#4a3a66', wallB:'#41355e', ceil:'#241c34', floor:'#5c4a72', corr:'#544868', corrF:'#6a5b80',
    warm:'rgba(255,186,104,0.20)', dark:'rgba(8,4,22,0.38)', gold:'#ffd54a', red:'#a3242a', text:'#f5efff'
  };
  var cv = document.getElementById('c'), ctx = cv.getContext('2d');
  var DPR = Math.min(2, window.devicePixelRatio||1);
  var VW=390, VH=844, TOP=64, BOT=186;
  var IMG = {};
  var paused=false, game=null, cam={x:0,y:0,z:1}, camManual=0, overview=false, scene='title', selTarget=null, tapMark=null;
  var staticCv=null, staticS=1;
  var save = loadSave();

  function loadSave(){ try { var s=JSON.parse(localStorage.getItem('lyg_m1')||'null'); if (s) return s; } catch(e){} return {nights:0, best:0, xianghuo:0, seed:1}; }
  function writeSave(){ try { localStorage.setItem('lyg_m1', JSON.stringify(save)); } catch(e){} }

  // ---------- 资源 ----------
  function loadImages(cb){
    var keys=Object.keys(window.LYG_IMG||{}), left=keys.length; if(!left) return cb();
    keys.forEach(function(k){ var im=new Image(); im.onload=im.onerror=function(){ if(--left===0) cb(); }; im.src=LYG_IMG[k]; IMG[k]=im; });
  }
  function sprite(key, x, y, h, flip, alpha){
    var im=IMG[key]; if(!im||!im.width) return 0;
    var w=h*im.width/im.height;
    if (alpha!==undefined && alpha<1) ctx.globalAlpha=alpha;
    if (flip){ ctx.save(); ctx.translate(x,0); ctx.scale(-1,1); ctx.drawImage(im,-w/2,y-h,w,h); ctx.restore(); }
    else ctx.drawImage(im,x-w/2,y-h,w,h);
    ctx.globalAlpha=1; return w;
  }

  // ---------- 尺寸 ----------
  function resize(){
    VW = Math.min(window.innerWidth, 520); VH = window.innerHeight;
    cv.style.width=VW+'px'; cv.style.height=VH+'px';
    cv.width=Math.round(VW*DPR); cv.height=Math.round(VH*DPR);
    BOT = Math.max(176, Math.min(210, Math.round(VH*0.23)));
    cam.zDefault = (VW)/430;
    if (!overview) cam.z = cam.zDefault;
    var s = Math.min(2, DPR*cam.zDefault*1.05);
    if (!staticCv || Math.abs(s-staticS)>0.05){ staticS=s; if (game) bakeStatic(); }
  }
  function viewH(){ return VH-TOP-BOT; }

  // ---------- 静态层（每夜烘一次）----------
  function rr(c,x,y,w,h,r){ c.beginPath(); c.moveTo(x+r,y); c.arcTo(x+w,y,x+w,y+h,r); c.arcTo(x+w,y+h,x,y+h,r); c.arcTo(x,y+h,x,y,r); c.arcTo(x,y,x+w,y,r); c.closePath(); }
  function bakeStatic(){
    var s=staticS; staticCv=document.createElement('canvas'); staticCv.width=Math.ceil(GEO.W*s); staticCv.height=Math.ceil(GEO.WH*s);
    var c=staticCv.getContext('2d'); c.scale(s,s); c.lineJoin='round';
    var R=S.rng(game.seed*31+7);
    // 天空
    var g=c.createLinearGradient(0,0,0,GEO.ROOF); g.addColorStop(0,C.sky0); g.addColorStop(1,C.sky1); c.fillStyle=g; c.fillRect(0,0,GEO.W,GEO.ROOF);
    for (var i=0;i<60;i++){ c.fillStyle='rgba(255,255,255,'+(0.3+R()*0.6)+')'; c.fillRect(R()*GEO.W,R()*GEO.ROOF*0.8,1.4,1.4); }
    c.fillStyle='#fff6d8'; c.beginPath(); c.arc(690,42,20,0,7); c.fill(); c.fillStyle=C.sky0; c.beginPath(); c.arc(681,36,18,0,7); c.fill();
    // 天台
    var ry=GEO.ROOF_Y;
    c.fillStyle='#4a3f60'; c.fillRect(0,ry,GEO.W,GEO.ROOF-ry);
    c.strokeStyle=C.ink; c.lineWidth=3; c.strokeRect(0,ry,GEO.W,GEO.ROOF-ry);
    // 水箱
    c.fillStyle='#6f8193'; rr(c,180,ry-74,100,70,6); c.fill(); c.stroke();
    c.fillStyle='#5a6b7c'; c.fillRect(186,ry-60,88,6); c.fillRect(186,ry-36,88,6);
    c.strokeStyle=C.ink; c.lineWidth=2; c.beginPath(); c.moveTo(190,ry-4); c.lineTo(190,ry+4); c.moveTo(270,ry-4); c.lineTo(270,ry+4); c.stroke();
    c.fillStyle='#e9e2ff'; c.font='bold 13px '+FONT; c.textAlign='center'; c.fillText('栖身处·天台水箱',230,ry-80);
    // 天线
    c.strokeStyle='#8a7fa0'; c.lineWidth=2; c.beginPath(); c.moveTo(560,ry); c.lineTo(560,ry-50); c.moveTo(540,ry-40); c.lineTo(580,ry-40); c.moveTo(545,ry-28); c.lineTo(575,ry-28); c.stroke();
    // 楼体
    for (var f=1; f<=GEO.FLOORS; f++) bakeFloor(c,f,R);
    // 地面层（底层空地）
    var gt=GEO.ROOF+GEO.FLOORS*GEO.RH;
    c.fillStyle='#3a3150'; c.fillRect(0,gt,GEO.W,110); c.fillStyle='#55496b'; c.fillRect(0,GEO.GROUND_Y,GEO.W,20);
    for (var px=130; px<GEO.W; px+=150){ c.fillStyle='#6a5c82'; c.fillRect(px,gt,16,GEO.GROUND_Y-gt); c.strokeStyle=C.ink; c.lineWidth=2; c.strokeRect(px,gt,16,GEO.GROUND_Y-gt); }
    // 保安亭
    c.fillStyle='#5e6f86'; rr(c,262,GEO.GROUND_Y-46,76,46,4); c.fill(); c.strokeStyle=C.ink; c.lineWidth=2.5; c.stroke();
    c.fillStyle='#1d2a3a'; c.fillRect(272,GEO.GROUND_Y-40,24,16); c.fillStyle='#7fb2d8'; c.fillRect(274,GEO.GROUND_Y-38,20,12);
    c.fillStyle='#fff'; c.font='bold 11px '+FONT; c.textAlign='center'; c.fillText('保安亭',300,GEO.GROUND_Y+14);
    // 信箱
    c.fillStyle='#7a6a40'; c.fillRect(410,GEO.GROUND_Y-50,60,40); c.strokeStyle=C.ink; c.strokeRect(410,GEO.GROUND_Y-50,60,40);
    for (var mx=0;mx<4;mx++) for (var my=0;my<3;my++){ c.strokeRect(412+mx*14.5,GEO.GROUND_Y-48+my*12.6,13,11); }
    // 拿督公神龛
    var dx=700, dy=GEO.GROUND_Y;
    c.fillStyle='#b8262c'; rr(c,dx-26,dy-58,52,58,3); c.fill(); c.strokeStyle=C.ink; c.lineWidth=2.5; c.stroke();
    c.fillStyle='#e8b23a'; c.beginPath(); c.moveTo(dx-34,dy-56); c.lineTo(dx,dy-78); c.lineTo(dx+34,dy-56); c.closePath(); c.fill(); c.stroke();
    c.fillStyle='#f3c94b'; c.fillRect(dx-14,dy-46,28,26); c.strokeRect(dx-14,dy-46,28,26);
    c.fillStyle='#7a1414'; c.fillRect(dx-20,dy-14,40,8);
    c.fillStyle='#fff3c8'; c.font='bold 11px '+FONT; c.fillText('拿督公',dx,dy-84);
    // 楼梯 / 电梯井 标签
    c.save(); c.fillStyle='rgba(255,255,255,0.75)'; c.font='bold 10px '+FONT; c.textAlign='center';
    c.fillText('楼梯',30,GEO.GROUND_Y-70); c.fillText('电梯井',80,GEO.GROUND_Y-70); c.restore();
    // 外框
    c.strokeStyle=C.ink; c.lineWidth=4; c.strokeRect(1,GEO.ROOF,GEO.W-2,GEO.FLOORS*GEO.RH+110);
  }
  function bakeFloor(c,f,R){
    var top=GEO.rowTop(f), RH=GEO.RH;
    // 楼梯间
    c.fillStyle='#3a3050'; c.fillRect(0,top,60,RH);
    c.strokeStyle='#7d6f98'; c.lineWidth=3; c.beginPath();
    for (var k=0;k<8;k++){ var sx=8+k*6, sy=top+RH-8-k*12; c.moveTo(sx,sy); c.lineTo(sx+6,sy); c.lineTo(sx+6,sy-12); }
    c.stroke();
    c.strokeStyle='#9a8db5'; c.lineWidth=1.5; c.beginPath(); c.moveTo(6,top+RH-20); c.lineTo(56,top+RH-110); c.stroke();
    // 电梯井
    c.fillStyle='#1b1527'; c.fillRect(60,top,40,RH);
    c.strokeStyle='#4a405e'; c.lineWidth=1.5; c.beginPath(); c.moveTo(74,top); c.lineTo(74,top+RH); c.moveTo(86,top); c.lineTo(86,top+RH); c.stroke();
    c.fillStyle='#9aa3b2'; c.fillRect(64,GEO.yCorr(f)-56,32,54); c.strokeStyle=C.ink; c.lineWidth=2; c.strokeRect(64,GEO.yCorr(f)-56,32,54);
    c.beginPath(); c.moveTo(80,GEO.yCorr(f)-56); c.lineTo(80,GEO.yCorr(f)-2); c.stroke();
    // 楼层号
    c.fillStyle='#ffe9a8'; c.font='bold 15px '+FONT; c.textAlign='center'; c.fillText(f+'楼',30,top+22);
    for (var u=0;u<3;u++) bakeUnit(c,f,u,R);
    // 走廊
    var cy=top+130;
    c.fillStyle=C.corr; c.fillRect(100,cy,GEO.W-100,70);
    c.fillStyle=C.corrF; c.fillRect(60,top+RH-8,GEO.W-60,8);
    c.fillStyle='#4a3e5e'; c.fillRect(0,top+RH-8,60,8);
    // 走廊灯
    for (var lx=150; lx<GEO.W; lx+=200){ c.fillStyle='#dfe9ff'; c.fillRect(lx,cy+3,26,4); }
    // 栏杆（前景）
    c.strokeStyle='rgba(20,13,34,0.55)'; c.lineWidth=1.5; c.beginPath(); c.moveTo(60,top+RH-22); c.lineTo(GEO.W,top+RH-22); c.stroke();
    // 楼板
    c.fillStyle=C.ink; c.fillRect(0,top+RH-2,GEO.W,4);
    c.fillRect(0,top,GEO.W,2);
  }
  function bakeUnit(c,f,u,R){
    var U=game.units[f+'_'+u], x0=GEO.unitX(u), top=GEO.rowTop(f), y0=top+22, yF=GEO.yRoom(f);
    // 天花夹层
    c.fillStyle=C.ceil; c.fillRect(x0,top,226,22);
    c.strokeStyle='#3a2f4d'; c.lineWidth=2; c.beginPath(); c.moveTo(x0+4,top+10); c.lineTo(x0+222,top+10); c.stroke();
    c.strokeStyle='#4c4062'; c.lineWidth=1; for (var k=0;k<10;k++){ c.beginPath(); c.moveTo(x0+12+k*22,top+3); c.lineTo(x0+12+k*22,top+19); c.stroke(); }
    // 客厅墙
    c.fillStyle=C.wallL; c.fillRect(x0,y0,113,108);
    c.fillStyle='rgba(255,255,255,0.035)'; for (var s=0;s<113;s+=10) c.fillRect(x0+s,y0,4,100);
    // 卧室墙
    c.fillStyle=C.wallB; c.fillRect(x0+113,y0,113,108);
    // 地板
    c.fillStyle=C.floor; c.fillRect(x0,yF-6,226,8);
    c.strokeStyle='rgba(20,13,34,0.4)'; c.lineWidth=1; for (var t=0;t<226;t+=16){ c.beginPath(); c.moveTo(x0+t,yF-6); c.lineTo(x0+t,yF+2); c.stroke(); }
    // 墙线
    c.strokeStyle=C.ink; c.lineWidth=4; c.beginPath(); c.moveTo(x0,top); c.lineTo(x0,top+130); c.moveTo(x0+226,top); c.lineTo(x0+226,top+130); c.stroke();
    c.lineWidth=3; c.beginPath(); c.moveTo(x0,y0); c.lineTo(x0+226,y0); c.stroke();
    // 客厅卧室之间的墙（带门洞）
    c.lineWidth=4; c.beginPath(); c.moveTo(x0+113,y0); c.lineTo(x0+113,yF-62); c.stroke();
    c.fillStyle='#2f2645'; c.fillRect(x0+109,yF-62,8,56);
    // 神台
    if (U.shrine){
      c.fillStyle='#7d1b1f'; rr(c,x0+6,yF-46,36,40,2); c.fill(); c.strokeStyle=C.ink; c.lineWidth=2; c.stroke();
      c.fillStyle='#c0392b'; rr(c,x0+8,yF-84,32,36,2); c.fill(); c.stroke();
      c.fillStyle='#f4c542'; c.fillRect(x0+16,yF-78,16,22); c.strokeRect(x0+16,yF-78,16,22);
      c.fillStyle='#ff5b4a'; c.beginPath(); c.arc(x0+11,yF-52,3,0,7); c.arc(x0+37,yF-52,3,0,7); c.fill();
      c.fillStyle='#b8863b'; c.fillRect(x0+18,yF-52,12,6); c.strokeRect(x0+18,yF-52,12,6);
      c.fillStyle='#e7c46a'; c.fillRect(x0+8,yF-30,32,3);
    }
    // 电视（挂墙）+ 沙发
    c.fillStyle='#16121f'; rr(c,x0+52,yF-92,40,24,2); c.fill(); c.strokeStyle=C.ink; c.lineWidth=2; c.stroke();
    c.fillStyle='#7a4a5c'; rr(c,x0+48,yF-26,50,20,5); c.fill(); c.stroke();
    c.fillStyle='#8e5a6e'; rr(c,x0+48,yF-34,50,10,4); c.fill(); c.stroke();
    // 小桌
    c.fillStyle='#8b6a46'; c.fillRect(x0+98,yF-22,14,4); c.fillRect(x0+100,yF-18,2,12); c.fillRect(x0+108,yF-18,2,12);
    // 卧室：床、衣柜、窗
    var bx=x0+113;
    c.fillStyle='#6d5b8e'; rr(c,bx+6,yF-26,58,20,3); c.fill(); c.strokeStyle=C.ink; c.lineWidth=2; c.stroke();
    c.fillStyle='#e8e1f2'; rr(c,bx+8,yF-32,16,8,3); c.fill(); c.stroke();
    c.fillStyle='#5a4870'; c.fillRect(bx+4,yF-44,5,38); c.strokeRect(bx+4,yF-44,5,38);
    c.fillStyle='#7b5236'; rr(c,bx+80,yF-80,30,74,2); c.fill(); c.stroke();
    c.beginPath(); c.moveTo(bx+95,yF-78); c.lineTo(bx+95,yF-8); c.stroke();
    c.fillStyle='#e0c07a'; c.fillRect(bx+91,yF-46,2,6); c.fillRect(bx+97,yF-46,2,6);
    c.fillStyle='#1d2850'; c.fillRect(bx+30,y0+12,30,26); c.strokeRect(bx+30,y0+12,30,26);
    c.beginPath(); c.moveTo(bx+45,y0+12); c.lineTo(bx+45,y0+38); c.stroke();
    c.fillStyle='rgba(255,255,255,0.7)'; c.fillRect(bx+36,y0+18,2,2); c.fillRect(bx+52,y0+28,2,2);
    // 走廊外墙：门、门牌、通风口、鞋架
    var cy=top+130, dxp=x0+78;
    c.fillStyle='#4e4262'; c.fillRect(x0,cy,226,62);
    c.strokeStyle=C.ink; c.lineWidth=2;
    c.fillStyle='#6a3c28'; c.fillRect(dxp-15,cy+8,30,54); c.strokeRect(dxp-15,cy+8,30,54);
    c.fillStyle='#e0c07a'; c.beginPath(); c.arc(dxp+9,cy+36,2,0,7); c.fill();
    c.fillStyle='#d8d0ea'; c.fillRect(dxp-12,cy-1,24,9); c.fillStyle=C.ink; c.font='bold 8px '+FONT; c.textAlign='center'; c.fillText(f+'-'+(u+1),dxp,cy+6);
    c.fillStyle='#7a6a8e'; c.fillRect(dxp-14,GEO.yCorr(f)-2,28,4); // 地垫
    c.fillStyle='#8f7a5a'; c.fillRect(dxp+20,cy+44,22,18); c.strokeRect(dxp+20,cy+44,22,18); c.fillRect(dxp+20,cy+52,22,1);
    var vx=x0+176; c.fillStyle='#2a2238'; c.fillRect(vx-12,cy+22,24,14); c.strokeRect(vx-12,cy+22,24,14);
    c.strokeStyle='#8a7fa0'; c.lineWidth=1; for (var v=0;v<4;v++){ c.beginPath(); c.moveTo(vx-10,cy+25+v*3); c.lineTo(vx+10,cy+25+v*3); c.stroke(); }
    c.fillStyle='rgba(255,255,255,0.55)'; c.font='9px '+FONT; c.fillText('通风口',vx,cy+46);
    // 房名
    c.fillStyle='rgba(255,240,210,0.8)'; c.font='bold 10px '+FONT; c.textAlign='left'; c.fillText('客厅',x0+4,y0+12); c.fillText('卧室',x0+117,y0+12);
  }

  // ---------- 相机 ----------
  function ghostPos(g){ return {x:g.x, y:g.y}; }
  function updateCam(dt){
    var vh=viewH();
    if (overview){ cam.z=Math.min(VW/GEO.W, vh/GEO.WH); cam.x=(GEO.W - VW/cam.z)/2; cam.y=(GEO.WH - vh/cam.z)/2; return; }
    cam.z=cam.zDefault;
    if (camManual>0){ camManual-=dt; }
    else {
      var g=game.ghosts[game.active], p=ghostPos(g);
      var tx=p.x-VW/cam.z/2, ty=p.y-80-vh/cam.z/2;
      cam.x+=(tx-cam.x)*Math.min(1,dt*4); cam.y+=(ty-cam.y)*Math.min(1,dt*4);
    }
    clampCam();
  }
  function clampCam(){ var vw=VW/cam.z, vh=viewH()/cam.z; cam.x=Math.max(0,Math.min(GEO.W-vw,cam.x)); cam.y=Math.max(-20,Math.min(GEO.WH-vh+10,cam.y)); }
  function toWorld(sx,sy){ return {x: sx/cam.z+cam.x, y:(sy-TOP)/cam.z+cam.y}; }
  function toScreen(wx,wy){ return {x:(wx-cam.x)*cam.z, y:(wy-cam.y)*cam.z+TOP}; }
  function worldT(){ ctx.setTransform(DPR*cam.z,0,0,DPR*cam.z,-cam.x*cam.z*DPR,(TOP-cam.y*cam.z)*DPR); }
  function screenT(){ ctx.setTransform(DPR,0,0,DPR,0,0); }

  // ---------- 动态绘制 ----------
  var animT=0;
  function drawWorld(){
    screenT(); ctx.save(); ctx.beginPath(); ctx.rect(0,TOP,VW,viewH()); ctx.clip();
    ctx.fillStyle=C.sky0; ctx.fillRect(0,TOP,VW,viewH());
    worldT();
    if (staticCv){
      var vx=Math.max(0,cam.x), vy=Math.max(0,cam.y), vw=Math.min(GEO.W-vx, VW/cam.z+2), vh2=Math.min(GEO.WH-vy, viewH()/cam.z+2);
      if (vw>0 && vh2>0) ctx.drawImage(staticCv, vx*staticS, vy*staticS, vw*staticS, vh2*staticS, vx, vy, vw, vh2);
    }
    var G=game;
    for (var k in G.units) drawUnitDyn(G.units[k]);
    drawTank();
    drawItems();
    // 保安手电
    G.guards.forEach(drawCone);
    // 拿督公
    G.datuk.forEach(function(d){
      if (!d.done && d.sweep>=0){
        var y=GEO.rowTop(d.f)+130, x=d.x;
        var gr=ctx.createLinearGradient(x-50,0,x+50,0); gr.addColorStop(0,'rgba(255,214,90,0)'); gr.addColorStop(0.5,'rgba(255,214,90,0.55)'); gr.addColorStop(1,'rgba(255,214,90,0)');
        ctx.fillStyle=gr; ctx.fillRect(x-50,y,100,70);
        ctx.fillStyle='#fff3c8'; ctx.font='bold 12px '+FONT; ctx.textAlign='center'; ctx.fillText('拿督公巡视',x,y+12);
      } else if (!d.done && d.warned){
        var y2=GEO.rowTop(d.f)+130; var a=0.25+0.2*Math.sin(animT*8);
        ctx.fillStyle='rgba(255,214,90,'+a+')'; ctx.fillRect(60,y2+60,GEO.W-60,6);
        ctx.fillStyle='#ffe9a8'; ctx.font='bold 12px '+FONT; ctx.textAlign='right'; ctx.fillText('铃声…拿督公将巡 '+d.f+'楼走廊 '+Math.max(0,Math.ceil(d.at-G.t))+'分',GEO.W-8,y2+56);
      }
    });
    // 住户、保安、鬼
    var units=G.units;
    buildLayout();
    G.residents.forEach(drawResident);
    G.guards.forEach(drawGuard);
    G.ghosts.forEach(function(g,i){ if (i!==G.active) drawGhost(g,i); });
    drawGhost(G.ghosts[G.active],G.active);
    // 路径
    var ag=G.ghosts[G.active];
    if (ag.path.length){ ctx.setLineDash([4,5]); ctx.strokeStyle='rgba(180,255,220,0.7)'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ag.x,ag.y-10);
      ag.path.forEach(function(id){ var n=GR.idx[id]; ctx.lineTo(n.x,n.y-10); }); ctx.stroke(); ctx.setLineDash([]); }
    if (tapMark && tapMark.t>0){ ctx.strokeStyle='rgba(180,255,220,'+tapMark.t+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(tapMark.x,tapMark.y,10+(1-tapMark.t)*12,0,7); ctx.stroke(); }
    // 吓人圈
    G.ghosts.forEach(function(g){ if (g.ring) drawRing(g); });
    ctx.restore();
    // 屏幕空间文字：气泡 + 飘字
    screenT(); ctx.save(); ctx.beginPath(); ctx.rect(0,TOP,VW,viewH()); ctx.clip();
    G.residents.forEach(function(r){ if (r.lineT>0 && visibleRes(r)) bubble(r.x, r.y-62, r.line); });
    G.guards.forEach(function(g){ if (g.lineT>0) bubble(g.x, g.y-66, g.line); });
    G.fx.forEach(function(f){
      var p=toScreen(f.x,f.y), a=Math.min(1,(1.8-f.t)*1.5), dy=-f.t*26;
      ctx.globalAlpha=a; ctx.font='bold 16px '+FONT; ctx.textAlign='center'; ctx.lineWidth=4; ctx.strokeStyle='rgba(15,8,30,0.9)';
      ctx.strokeText(f.text,p.x,p.y+dy); ctx.fillStyle=f.color; ctx.fillText(f.text,p.x,p.y+dy); ctx.globalAlpha=1;
    });
    ctx.restore();
  }
  function drawTank(){
    var g=game.ghosts.some(function(x){return x.node==='TANK';});
    var a=0.25+0.15*Math.sin(animT*2);
    ctx.fillStyle='rgba(140,255,200,'+a+')'; ctx.fillRect(176,GEO.ROOF_Y-6,108,6);
  }
  function unitIsLight(U,room){ return U.light[room]; }
  function drawUnitDyn(U){
    var x0=GEO.unitX(U.u), top=GEO.rowTop(U.f), y0=top+22, yF=GEO.yRoom(U.f), G=game, ag=G.ghosts[G.active];
    // 灯光
    ['L','B'].forEach(function(room,ri){
      var rx=x0+ri*113;
      var lit=U.light[room] && !(U.flicker>0 && Math.sin(animT*40)>0);
      ctx.fillStyle= lit? C.warm : C.dark; ctx.fillRect(rx,y0,113,108);
    });
    // 电视光
    if (U.residents.some(function(r){return r.state==='tv'&&r.node==='L'+U.id&&!r.edge;})){
      ctx.fillStyle='rgba(120,190,255,'+(0.55+0.25*Math.sin(animT*7+U.u))+')'; ctx.fillRect(x0+54,yF-90,36,20);
    }
    // 宵夜（在桌上，人人看得见；饿鬼王隔墙闻到会高亮）
    if (U.supper && !U.supper.eaten){
      ctx.fillStyle='#f2efe6'; ctx.beginPath(); ctx.ellipse(x0+105,yF-25,7,3.5,0,0,7); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=1.2; ctx.stroke();
      ctx.fillStyle='#d9862e'; ctx.beginPath(); ctx.ellipse(x0+105,yF-27,5,2,0,0,7); ctx.fill();
      if (ag.id==='eking'){
        var a=0.5+0.4*Math.sin(animT*5);
        ctx.strokeStyle='rgba(255,213,74,'+a+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(x0+105,yF-26,12,0,7); ctx.stroke();
        label(x0+72,y0+12,U.supper.name+' '+eatLeft(U),'#ffd54a',10);
      }
    }
    // 钱（Toyol 才看得到）
    if (ag.id==='toyol') U.money.forEach(function(m,i){ if (m.gone) return; var mx= m.room==='L'? x0+60+i*10 : x0+113+48+i*10;
      ctx.fillStyle='#ffd54a'; ctx.beginPath(); ctx.arc(mx,yF-14,5,0,7); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=1.2; ctx.stroke();
      label(mx,yF-24,'RM'+m.amt,'#ffe9a8',9); });
    // 私房钱（天花姐看得到）
    if (U.stash && !U.stash.gone && (ag.id==='tianhua')){
      var sx=x0+113+95, sy=yF-84;
      ctx.fillStyle='#c94a3a'; ctx.fillRect(sx-8,sy-6,16,6); ctx.strokeStyle=C.ink; ctx.lineWidth=1.2; ctx.strokeRect(sx-8,sy-6,16,6);
      var a2=0.5+0.4*Math.sin(animT*5); ctx.strokeStyle='rgba(255,213,74,'+a2+')'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(sx,sy-3,11,0,7); ctx.stroke();
      label(sx-14,sy-14,'私房钱','#ffd54a',10);
    }
    // 香 + 神光
    if (U.shrine){
      if (U.incense>0){
        ctx.strokeStyle='#c9a46a'; ctx.lineWidth=1.2; ctx.beginPath();
        for (var s=0;s<3;s++){ ctx.moveTo(x0+21+s*3,yF-52); ctx.lineTo(x0+21+s*3,yF-62); } ctx.stroke();
        ctx.fillStyle='#ff6a3a'; for (var s2=0;s2<3;s2++) ctx.fillRect(x0+20.5+s2*3,yF-63,1.6,1.6);
        ctx.strokeStyle='rgba(230,230,240,0.35)'; ctx.beginPath(); ctx.moveTo(x0+24,yF-64); ctx.quadraticCurveTo(x0+30+Math.sin(animT*2)*4,yF-74,x0+24,yF-86); ctx.stroke();
      }
      var lr=game.lightRect(U);
      if (lr){
        var al = lr.lvl===2?0.30:(lr.lvl===1?0.22:0.12);
        ctx.fillStyle='rgba(255,222,120,'+al+')'; ctx.fillRect(lr.x0,lr.y0,lr.x1-lr.x0,lr.y1-lr.y0);
        ctx.setLineDash([5,4]); ctx.strokeStyle='rgba(255,226,140,0.85)'; ctx.lineWidth=1.5; ctx.strokeRect(lr.x0+1,lr.y0+1,lr.x1-lr.x0-2,lr.y1-lr.y0-2); ctx.setLineDash([]);
        var txt = lr.lvl===2?'拜神中':(lr.lvl===1?'香 剩'+Math.ceil(U.incense)+'分':'神光');
        label(x0+24,y0+26,txt,'#ffe9a8',10);
      }
    }
    // 门
    var dxp=x0+78, cy=top+130, yc=GEO.yCorr(U.f);
    if (U.locked){ ctx.strokeStyle='#c8c8d4'; ctx.lineWidth=1.6; ctx.beginPath(); for (var b=0;b<6;b++){ ctx.moveTo(dxp-15+b*6,cy+8); ctx.lineTo(dxp-15+b*6,cy+62); } ctx.moveTo(dxp-16,cy+20); ctx.lineTo(dxp+16,cy+20); ctx.moveTo(dxp-16,cy+46); ctx.lineTo(dxp+16,cy+46); ctx.stroke(); }
    else { ctx.fillStyle='rgba(20,10,30,0.7)'; ctx.fillRect(dxp-13,cy+10,26,52); }
    if (U.doorGod){
      [-1,1].forEach(function(sd){ var px=dxp+sd*8-5; ctx.fillStyle='#c0262c'; ctx.fillRect(px,cy+14,10,22); ctx.strokeStyle='#f3c94b'; ctx.lineWidth=1; ctx.strokeRect(px+1,cy+15,8,20); });
      label(dxp,cy+44,'门神','#ffd54a',9);
    }
    if (U.key && U.locked && (ag.id!=='tianhua')){ ctx.fillStyle='#ffd54a'; ctx.fillRect(dxp-3,yc-3,6,2); }
    if (U.salt){ ctx.fillStyle='#f5f5f5'; for (var sx2=-16; sx2<=16; sx2+=3) ctx.fillRect(dxp+sx2,yc-4+((sx2*7)%3),1.8,1.8); label(dxp,yc+8,'盐','#ffffff',9); }
    // 洗澡
    var sh=U.residents.filter(function(r){return r.state==='shower'&&!r.edge;});
    if (sh.length) label(x0+113+30,y0+52,sh[0].name+'冲凉中','#bfe6ff',10);
  }
  function eatLeft(U){ var m=Math.max(0,Math.ceil(U.supper.eatAt-game.t)); return m>0? m+'分':'快被吃'; }
  function label(x,y,t,col,sz){ ctx.font='bold '+(sz||10)+'px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='rgba(15,8,30,0.85)'; ctx.strokeText(t,x,y); ctx.fillStyle=col; ctx.fillText(t,x,y); }
  function visibleRes(r){ return r.state!=='shower' || r.edge; }
  function resPos(r){
    var x=r.x, y=r.y;
    if (!r.edge){ var n=GR.idx[r.node]; if (n.lane==='room'){ var x0=GEO.unitX(n.u)+(n.room==='B'?113:0);
      if (n.room==='L') x = x0 + (r.slot? 92: 56); else x = x0 + (r.slot? 92:60); } }
    return {x:x,y:y};
  }
  // 同一房间里的人和鬼并排摆，不重叠、不出房间
  var LAYOUT={};
  function sprW(key,h){ var im=IMG[key]; return (im&&im.width)? h*im.width/im.height : h*0.6; }
  function resKey(r){ var n=GR.idx[r.node], key=r.sprite; if (r.state==='tv' && n.room==='L' && (key==='npc_ken'||key==='npc_it')) key=key+'_sit'; return key; }
  function buildLayout(){
    LAYOUT={}; var G=game, rooms={};
    function add(nid,obj,w){ (rooms[nid]=rooms[nid]||[]).push({o:obj,w:w}); }
    G.residents.forEach(function(r){ if (r.edge || r.state==='shower') return; var n=GR.idx[r.node]; if (n.lane!=='room') return;
      if (n.room==='B' && (r.state==='sleep'||r.state==='hide')) return; var k=resKey(r); add(n.id,r,sprW(k,k.indexOf('_sit')>0?48:54)); });
    G.guards.forEach(function(g){ if (g.edge) return; var n=GR.idx[g.node]; if (n.lane==='room') add(n.id,g,sprW('npc_guard',58)); });
    G.ghosts.forEach(function(g){ if (g.edge) return; var n=GR.idx[g.node]; if (n.lane==='room'){ var D=DATA.ghosts[g.id]; add(n.id,g,sprW(D.sprite,D.h)); } });
    for (var nid in rooms){
      var n=GR.idx[nid], list=rooms[nid], x0=GEO.unitX(n.u)+(n.room==='B'?113:0)+4, span=105;
      var tot=list.reduce(function(a,b){return a+b.w;},0), sc=Math.min(1, span/tot), gap=Math.max(0,(span-tot*sc)/(list.length+1)), x=x0+gap;
      if (list.length===1){ var only=list[0]; var cx = n.room==='L'? x0+70 : x0+40; LAYOUT[only.o===undefined?'':(only.o.id)]={x:Math.min(x0+span-only.w/2, Math.max(x0+only.w/2,cx)), s:1}; continue; }
      list.forEach(function(it){ var w=it.w*sc; LAYOUT[it.o.id]={x:x+w/2, s:sc}; x+=w+gap; });
    }
  }
  function drawResident(r){
    if (r.state==='shower' && !r.edge) return;
    var n=GR.idx[r.node];
    if (!r.edge && n.lane==='room' && n.room==='B' && (r.state==='sleep'||r.state==='hide')){
      var x0=GEO.unitX(n.u)+113, yF=GEO.yRoom(n.f), shake = r.state==='hide'? Math.sin(animT*30)*1.2:0;
      var bx=x0+14+r.slot*22+shake;
      ctx.fillStyle= r.state==='hide'?'#9b7fc0':'#8c78b4'; rr(ctx,bx,yF-34,30,12,6); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=1.5; ctx.stroke();
      label(bx+15,yF-38, r.state==='hide'?'发抖':'Zzz', r.state==='hide'?'#ffb0d0':'#cfd8ff',9);
      label(bx+15,yF-50, r.name,'#fff',9);
      r.x=bx+15; r.y=yF-6;
      return;
    }
    var p={x:r.x,y:r.y}, key=r.edge? r.sprite : resKey(r);
    var h = (key.indexOf('_sit')>0)?48:54;
    var L0=!r.edge && LAYOUT[r.id]; if (L0){ p.x=L0.x; r.x=L0.x; h*=L0.s; }
    var bob = r.edge? Math.abs(Math.sin(animT*10))*2:0;
    sprite(key,p.x,p.y-bob,h,(r.dir||1)<0);
    var col = r.tier>=3?'#ff5d5d':(r.tier>=1?'#ffd27a':'#fff');
    label(p.x,p.y-h-4,r.name,col,10);
    // 恐惧条
    if (r.fear>1){ ctx.fillStyle='rgba(0,0,0,0.5)'; ctx.fillRect(p.x-14,p.y-h-18,28,4); ctx.fillStyle='#ff6f9a'; ctx.fillRect(p.x-14,p.y-h-18,28*Math.min(1,r.fear/90),4); }
    if (game.ghosts[game.active].target===r){ ctx.strokeStyle='#ffd54a'; ctx.lineWidth=2; ctx.beginPath(); ctx.ellipse(p.x,p.y,18,5,0,0,7); ctx.stroke(); }
  }
  function drawCone(g){
    var c=game.guardCone(g); if(!c) return;
    ctx.save();
    if (c.vertical){
      ctx.fillStyle='rgba(255,240,170,0.18)'; ctx.beginPath(); ctx.arc(c.x,c.y,c.len,0,7); ctx.fill();
    } else {
      // 预警边缘
      ctx.fillStyle='rgba(255,240,170,0.10)'; ctx.beginPath(); ctx.moveTo(c.x,c.y);
      ctx.arc(c.x,c.y,c.warn, c.dir>0? -c.wang: Math.PI-c.wang, c.dir>0? c.wang: Math.PI+c.wang); ctx.closePath(); ctx.fill();
      ctx.setLineDash([4,4]); ctx.strokeStyle='rgba(255,240,170,0.5)'; ctx.lineWidth=1.2; ctx.stroke(); ctx.setLineDash([]);
      ctx.fillStyle='rgba(255,244,190,0.34)'; ctx.beginPath(); ctx.moveTo(c.x,c.y);
      ctx.arc(c.x,c.y,c.len, c.dir>0? -c.ang: Math.PI-c.ang, c.dir>0? c.ang: Math.PI+c.ang); ctx.closePath(); ctx.fill();
    }
    ctx.restore();
  }
  function drawGuard(g){
    var flee=g.flee>0, bob=g.edge?Math.abs(Math.sin(animT*9))*2:0;
    if (g.mode==='doze'){ sprite('npc_guard',g.x-20,g.y,56,false); label(g.x-20,g.y-62,g.name+' 打瞌睡','#cfd8ff',10); return; }
    var gx=g.x, gh=58; if(!g.edge && LAYOUT[g.id]){ gx=LAYOUT[g.id].x; gh*=LAYOUT[g.id].s; }
    sprite('npc_guard',gx,g.y-bob,gh,(g.dir||1)>0, flee?0.85:1);
    var st = flee?'逃跑中':(g.mode==='hunt'?'搜捕':(g.mode==='alert'?'留意':'巡楼'));
    label(gx,g.y-64,g.name+'·'+st, g.mode==='hunt'?'#ff7a7a':(g.mode==='alert'?'#ffd27a':'#d8e4ff'),10);
  }
  function drawGhost(g,i){
    var act = i===game.active, D=DATA.ghosts[g.id];
    var n=GR.idx[g.node], lane = g.edge? g.edge.e.type : n.lane;
    var alpha = g.hide?0.35:(g.reveal>0?1:0.82);
    if (g.respawn>0) alpha*=0.5;
    var x=g.x, y=g.y;
    if (g.node==='TANK' && !g.edge){ x=[146,312,356][i]; }
    // 房间里有人时鬼站位稍偏，避免重叠
    var gsc=1; if (!g.edge && n.lane==='room' && LAYOUT[g.id]){ x=LAYOUT[g.id].x; gsc=LAYOUT[g.id].s; }
    if (g.id==='tianhua' && (lane==='ceil'||lane==='climb'||(lane==='shaft'))){
      var hy = (lane==='shaft')? y-60 : GEO.yCeil(n.f||1)-14;
      if (g.edge && lane!=='ceil') hy = y-60;
      var drop = g.hang>0? 22:0;
      if (lane==='ceil' && n.room){ x = GEO.unitX(n.u)+(n.room==='B'?113+44:82); }
      sprite('tianhua_hang',x,hy+70+drop,70, false, g.hang>0?1:(g.hide?0.35:0.6));
      if (act) ghostMarker(x,hy-2);
    } else if (lane==='shaft' || (g.edge && g.edge.e.type==='shaft')){
      sprite(D.sprite,x,y,D.h*0.85,(g.dir||1)<0,0.55);
      if (act) ghostMarker(x,y-D.h-6);
    } else {
      var bob=Math.sin(animT*3+i)*2;
      sprite(D.sprite,x,y-4+bob,D.h*gsc,(g.dir||1)<0,alpha);
      if (act) ghostMarker(x,y-D.h-10);
    }
    if (g.stun>0){ label(x,y-D.h-24,'被镇住','#ffe08a',11); }
    if (g.channel){ var pr=Math.min(1,g.channel.t/g.channel.dur); ctx.fillStyle='rgba(0,0,0,0.6)'; ctx.fillRect(x-20,y-D.h-30,40,6); ctx.fillStyle='#ffd54a'; ctx.fillRect(x-20,y-D.h-30,40*pr,6); }
    if (g.hide){ label(x,y-D.h-24, g.hide==='wardrobe'?'躲在衣柜':'躲在沙发底','#9ad0ff',10); }
    if (g.exposure>0.05 && g.lit){ ctx.fillStyle='rgba(0,0,0,0.6)'; ctx.fillRect(x-18,y-D.h-36,36,5); ctx.fillStyle='#ff5d5d'; ctx.fillRect(x-18,y-D.h-36,36*Math.min(1,g.exposure/2),5); }
  }
  function ghostMarker(x,y){ ctx.fillStyle='#8affc8'; ctx.beginPath(); ctx.moveTo(x-6,y-8); ctx.lineTo(x+6,y-8); ctx.lineTo(x,y); ctx.closePath(); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=1.5; ctx.stroke(); }
  function drawRing(g){
    var t=g.ring.target, cx=t.x, cy=t.y-30, r=game.ringRadius(g.ring);
    ctx.setLineDash([3,3]); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=2.5; ctx.beginPath(); ctx.arc(cx,cy,game.RING_IN,0,7); ctx.stroke(); ctx.setLineDash([]);
    var perfect=Math.abs(r-game.RING_IN)<=5;
    ctx.strokeStyle= perfect?'#fff27a':'#ff7ab0'; ctx.lineWidth= perfect?4:3; ctx.beginPath(); ctx.arc(cx,cy,r,0,7); ctx.stroke();
  }
  function drawItems(){
    game.items.forEach(function(it){
      if (it.type==='oil'){ ctx.fillStyle='#7be0b0'; rr(ctx,it.x-5,it.y-14,10,12,3); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=1.2; ctx.stroke(); label(it.x,it.y-18,'魂灯油','#9affc8',9); }
      else if (it.type==='radio'){ ctx.fillStyle='#333'; ctx.fillRect(it.x-4,it.y-14,8,13); ctx.fillStyle='#ff4040'; ctx.fillRect(it.x-1,it.y-17,2,3); label(it.x,it.y-20,'对讲机','#fff',9); }
      else if (it.type==='drop'){ var a=0.6+0.3*Math.sin(animT*6); ctx.fillStyle='rgba(255,213,74,'+a+')'; ctx.beginPath(); ctx.arc(it.x,it.y-6,6,0,7); ctx.fill(); label(it.x,it.y-16,'掉落 '+Math.ceil(it.ttl)+'秒','#ffd54a',9); }
    });
  }
  function bubble(wx,wy,text){
    var p=toScreen(wx,wy); ctx.font='14px '+FONT;
    var maxW=Math.min(200,VW-24), lines=wrap(text,maxW-16), w=0; lines.forEach(function(l){ w=Math.max(w,ctx.measureText(l).width); });
    var bw=w+16, bh=lines.length*18+10, bx=Math.max(8,Math.min(VW-bw-8,p.x-bw/2)), by=p.y-bh-6;
    if (by<TOP+4) by=TOP+4;
    ctx.fillStyle='rgba(255,252,240,0.95)'; rr(ctx,bx,by,bw,bh,8); ctx.fill(); ctx.strokeStyle=C.ink; ctx.lineWidth=2; ctx.stroke();
    ctx.fillStyle='#1d1530'; ctx.textAlign='left'; lines.forEach(function(l,i){ ctx.fillText(l,bx+8,by+19+i*18); });
  }
  var NOHEAD='，。！？、；：）」』”…·';
  function wrap(t,maxW){ var out=[], cur=''; for (var i=0;i<t.length;i++){ var c=t[i]; if (ctx.measureText(cur+c).width>maxW && cur && NOHEAD.indexOf(c)<0){ out.push(cur); cur=c; } else cur+=c; } if(cur) out.push(cur); return out; }

  // ---------- UI ----------
  var buttons=[];
  function btn(id,x,y,w,h,text,opt){ opt=opt||{}; buttons.push({id:id,x:x,y:y,w:w,h:h});
    ctx.fillStyle=opt.bg||'#3a2c58'; rr(ctx,x,y,w,h,10); ctx.fill(); ctx.strokeStyle=opt.border||'#120a20'; ctx.lineWidth=2.5; ctx.stroke();
    if (opt.dim){ ctx.fillStyle='rgba(10,5,20,0.45)'; rr(ctx,x,y,w,h,10); ctx.fill(); }
    ctx.fillStyle=opt.color||'#fff'; ctx.textAlign='center'; ctx.font='bold '+(opt.size||17)+'px '+FONT; ctx.fillText(text,x+w/2,y+h/2+(opt.sub?-2:6));
    if (opt.sub){ ctx.font=(opt.subSize||11)+'px '+FONT; ctx.fillStyle='rgba(255,255,255,0.8)'; ctx.fillText(opt.sub,x+w/2,y+h/2+15); }
  }
  function drawUI(){
    screenT(); buttons=[];
    var G=game;
    // 顶栏
    ctx.fillStyle='#1a1130'; ctx.fillRect(0,0,VW,TOP); ctx.fillStyle='#2a1c46'; ctx.fillRect(0,TOP-3,VW,3);
    ctx.fillStyle='#ffe9a8'; ctx.font='bold 26px '+FONT; ctx.textAlign='left'; ctx.fillText(G.clock(),12,34);
    ctx.font='12px '+FONT; ctx.fillStyle='rgba(255,255,255,0.75)'; ctx.fillText('离天亮 '+Math.max(0,Math.ceil(S.NIGHT-G.t))+' 分钟 · 惊魂 '+G.scares,12,54);
    var al=['平时','留意','搜捕'][G.alert], alc=['#4a8a6a','#c58a2a','#c23a3a'][G.alert];
    ctx.fillStyle=alc; rr(ctx,VW-196,14,74,34,17); ctx.fill(); ctx.fillStyle='#fff'; ctx.font='bold 15px '+FONT; ctx.textAlign='center'; ctx.fillText('警戒·'+al,VW-159,36);
    btn('overview',VW-112,12,100,38,overview?'回到鬼':'看全楼',{size:15,bg:'#3d3266'});
    if (G.ghosts.every(function(g){return G.commDone(g.id);})) btn('finish',94,10,52,30,'收工',{size:14,bg:'#2f6a55'});
    btn('pause',VW-242,14,42,34,paused?'继续':'暂停',{size:13,bg:'#3d3266'});
    // toast
    if (G.lastToast){ ctx.font='bold 14px '+FONT; var lines=wrap(G.lastToast.msg,VW-48); var h=lines.length*19+12;
      ctx.globalAlpha=Math.min(1,G.lastToast.t*2); ctx.fillStyle='rgba(12,6,26,0.85)'; rr(ctx,12,TOP+8,VW-24,h,10); ctx.fill(); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=1.5; ctx.stroke();
      ctx.fillStyle='#fff3c8'; ctx.textAlign='center'; lines.forEach(function(l,i){ ctx.fillText(l,VW/2,TOP+27+i*19); }); ctx.globalAlpha=1; }
    // 底部面板
    var by=VH-BOT; ctx.fillStyle='#1a1130'; ctx.fillRect(0,by,VW,BOT); ctx.fillStyle='#2a1c46'; ctx.fillRect(0,by,VW,3);
    // 鬼卡
    var cw=(VW-16-12)/3;
    G.ghosts.forEach(function(g,i){
      var x=8+i*(cw+6), y=by+8, h=66, act=i===G.active;
      buttons.push({id:'ghost'+i,x:x,y:y,w:cw,h:h});
      ctx.fillStyle=act?'#4b3a78':'#2c2148'; rr(ctx,x,y,cw,h,10); ctx.fill(); ctx.strokeStyle=act?'#8affc8':'#120a20'; ctx.lineWidth=act?2.5:2; ctx.stroke();
      var im=IMG[DATA.ghosts[g.id].sprite]; if (im&&im.width){ var ih=54, iw=ih*im.width/im.height; ctx.drawImage(im,x+4,y+6,iw,ih); }
      ctx.textAlign='left'; ctx.fillStyle='#fff'; ctx.font='bold 14px '+FONT; ctx.fillText(g.name,x+48,y+19);
      // 魂力
      ctx.fillStyle='rgba(0,0,0,0.5)'; ctx.fillRect(x+48,y+26,cw-54,7); ctx.fillStyle=g.soul>30?'#8affc8':'#ff7a7a'; ctx.fillRect(x+48,y+26,(cw-54)*g.soul/100,7);
      var pr=G.commProgress(g.id), txt;
      if (g.id==='eking') txt='宵夜 '+pr.done+'/3'+(pr.carry?' 肚+'+pr.carry:'');
      else if (g.id==='toyol') txt='RM'+pr.done+'/50'+(pr.carry?' 身+'+pr.carry:'');
      else txt= pr.done?'私房钱 ✓':(pr.carry?'私房钱在身':'私房钱 0/1');
      if (G.commDone(g.id)) txt='委托完成 ✓';
      ctx.font='12px '+FONT; ctx.fillStyle=G.commDone(g.id)?'#8affc8':'#ffe9a8'; ctx.fillText(txt,x+48,y+50);
      if (g.stun>0||g.respawn>0){ ctx.fillStyle='#ff9a9a'; ctx.fillText(g.stun>0?'定身':'回魂',x+48,y+63); }
      else if (g.hide){ ctx.fillStyle='#9ad0ff'; ctx.fillText('躲着',x+48,y+63); }
    });
    // 信息栏
    var ag=G.ghosts[G.active], iy=by+82, iw=VW-16-150;
    ctx.fillStyle='#24193d'; rr(ctx,8,iy,iw,BOT-90,10); ctx.fill();
    ctx.textAlign='left'; ctx.fillStyle='#ffd54a'; ctx.font='bold 13px '+FONT;
    var cl=wrap('委托：'+G.comm[ag.id].text, iw-16); ctx.fillText(cl[0],16,iy+19); if (cl[1]) ctx.fillText(cl[1],16,iy+36);
    var info=placeInfo(ag), yy=iy+(cl[1]?54:38);
    ctx.font='13px '+FONT;
    info.forEach(function(l){ var ls=wrap(l.t,iw-16); ls.forEach(function(s){ if (yy<VH-8){ ctx.fillStyle=l.c||'#e8e0ff'; ctx.fillText(s,16,yy); yy+=17; } }); });
    // 动作按钮（右侧）
    var cx0=VW-150+4, bw=68, bh=(BOT-96)/2;
    var cxt=G.ghostContext(G.active);
    var ringOn=!!ag.ring, perfect = ringOn && Math.abs(G.ringRadius(ag.ring)-G.RING_IN)<=5;
    btn('scare',cx0,iy,bw,bh, ringOn?'爆点!':'吓', {bg: ringOn?(perfect?'#d4a017':'#a83266'):'#7a2a55', size:ringOn?19:20, dim:!ringOn&&!cxt.scare, sub: ringOn?null:(cxt.scare?'铺垫→爆点':'没目标'), subSize:10});
    btn('take',cx0+bw+6,iy,bw,bh, cxt.take?shortLabel(cxt.take.label):'拿', {bg:'#2f6a55', dim:!cxt.take, size: cxt.take?14:20});
    btn('hide',cx0,iy+bh+6,bw,bh, ag.hide?'出来':'躲', {bg:'#2d4f7a', dim:!cxt.hide&&!ag.hide});
    btn('radio',cx0+bw+6,iy+bh+6,bw,bh, '对讲机', {bg:'#555', dim:!ag.radio, size:14, sub: ag.radio?'假消息':'没有', subSize:10});
  }
  function shortLabel(s){ return s.length>4? s.slice(0,4): s; }
  var actName={tv:'看电视',sleep:'睡觉',shower:'冲凉',night:'起夜',pray:'上香',salt:'撒盐',hide:'躲被子',flee:'逃出屋',check:'起身查看',back:'回家',eat:'吃宵夜'};
  function placeInfo(g){
    var G=game, n=GR.idx[g.node], out=[];
    if (g.node==='TANK') { out.push({t:'在天台水箱：回魂力，带回的东西在这里存好。'}); out.push({t:'点楼里的房间移动；点人物选目标。',c:'#bfb3e0'}); return out; }
    if (!n.f || n.f<1 || n.f>6){ out.push({t: n.lane==='lobby'?'楼下大堂':'天台'}); return out; }
    if (n.u===undefined){ out.push({t:n.f+'楼 '+(n.lane==='shaft'?'电梯井（保安和拿督公照不到）':(n.lane==='ceil'?'天花夹层':'楼梯口'))}); return out; }
    var U=G.units[n.f+'_'+n.u];
    var where = n.lane==='ceil'?'天花夹层':(n.lane==='corr'?'走廊':(n.room==='L'?'客厅':'卧室'));
    var flags=[]; if (U.doorGod) flags.push('门神'); if (U.locked) flags.push('铁闸锁着'); if (U.salt) flags.push('门口有盐'); if (U.shrine) flags.push(U.incense>0?'香剩'+Math.ceil(U.incense)+'分':'神台没点香');
    out.push({t:U.name+' '+where+(flags.length?' · '+flags.join(' '):''), c:'#fff'});
    U.residents.forEach(function(r){
      var nxt=null; for (var i=0;i<r.sched.length;i++) if (r.sched[i].t>G.t){ nxt=r.sched[i]; break; }
      var s=r.name+'：'+(actName[r.state]||r.state)+(nxt?' → '+toClock(nxt.t)+actName[nxt.act]:'');
      out.push({t:s, c: r.tier>=2?'#ffb0d0':'#d8d0f0'});
    });
    if (!U.residents.length) out.push({t:'这户没人住', c:'#9a90b8'});
    return out;
  }
  function toClock(t){ var m=Math.floor(23*60+t)%1440; var h=Math.floor(m/60), mm=m%60; return (h<10?'0':'')+h+':'+(mm<10?'0':'')+mm; }

  // ---------- 标题 / 结算 ----------
  function drawTitle(){
    screenT(); buttons=[];
    var g=ctx.createLinearGradient(0,0,0,VH); g.addColorStop(0,'#120a26'); g.addColorStop(1,'#2b1a4a'); ctx.fillStyle=g; ctx.fillRect(0,0,VW,VH);
    ctx.textAlign='center'; ctx.fillStyle='#ffe9a8'; ctx.font='bold 44px '+FONT; ctx.fillText('楼里有鬼',VW/2,92);
    ctx.font='15px '+FONT; ctx.fillStyle='#cfc3ee'; ctx.fillText('M1 测试版 · 一栋组屋，一夜，三只鬼',VW/2,122);
    var names=['eguiking','toyol','tianhua'], cw=VW/3;
    names.forEach(function(k,i){ var im=IMG[k]; if (im&&im.width){ var h=120, w=h*im.width/im.height; ctx.drawImage(im,cw*i+cw/2-w/2,150,w,h); } });
    ctx.font='bold 15px '+FONT; ctx.fillStyle='#fff'; ['饿鬼王','Toyol','天花姐'].forEach(function(n,i){ ctx.fillText(n,cw*i+cw/2,290); });
    ctx.font='12px '+FONT; ctx.fillStyle='#bfb3e0'; ['闻得到宵夜·吃了回魂','钻通风口·偷钱最快','爬天花·盐挡不住'].forEach(function(n,i){ ctx.fillText(n,cw*i+cw/2,308); });
    var tips=['点楼里的房间：鬼自动走过去。点人物：选为吓人目标。','「吓」按一下是铺垫，金圈收紧时再按「爆点」，对准金圈＝完美时机×2。','屋里有人看着不能拿东西：先把人吓去拜神、吓到躲被子或吓到逃出屋。','金色虚线框是神光：香点着时罩满客厅，进去会被镇住。门神门、门口的盐要绕路。','保安手电照满 2 秒会被抓：身上的东西掉一半，打回水箱。','东西要带回天台水箱才算数。06:00 天亮结算。'];
    ctx.textAlign='left'; ctx.font='14px '+FONT; var y=346;
    tips.forEach(function(t){ var ls=wrap('· '+t,VW-48); ls.forEach(function(l){ ctx.fillStyle='#ece6ff'; ctx.fillText(l,24,y); y+=21; }); y+=4; });
    btn('start',VW/2-110,Math.min(VH-150,y+16),220,58,'开始这一夜',{bg:'#7a2a55',size:22});
    ctx.textAlign='center'; ctx.font='13px '+FONT; ctx.fillStyle='#9a90b8';
    ctx.fillText('已玩 '+save.nights+' 夜 · 最佳 '+save.best+' 星 · 香火 '+save.xianghuo,VW/2,Math.min(VH-150,y+16)+86);
  }
  function drawResult(){
    var r=game.result; screenT(); buttons=[];
    ctx.fillStyle='rgba(10,5,22,0.88)'; ctx.fillRect(0,0,VW,VH);
    var x=20, w=VW-40, y=110;
    ctx.fillStyle='#24193d'; rr(ctx,x,y,w,500,16); ctx.fill(); ctx.strokeStyle='#ffd54a'; ctx.lineWidth=2; ctx.stroke();
    ctx.textAlign='center'; ctx.fillStyle='#ffe9a8'; ctx.font='bold 28px '+FONT; ctx.fillText('天亮了',VW/2,y+46);
    for (var i=0;i<3;i++) star(VW/2-60+i*60,y+96,22,i<r.stars);
    ctx.font='bold 16px '+FONT; ctx.textAlign='left'; var yy=y+156;
    r.comms.forEach(function(c){ ctx.fillStyle=c.ok?'#8affc8':'#ff9a9a'; ctx.fillText((c.ok?'✓ ':'✗ ')+c.name,x+20,yy); ctx.font='14px '+FONT; ctx.fillStyle='#e8e0ff';
      var ls=wrap(c.text,w-60); ls.forEach(function(l){ yy+=20; ctx.fillText(l,x+40,yy); }); yy+=30; ctx.font='bold 16px '+FONT; });
    ctx.font='15px '+FONT; ctx.fillStyle='#fff';
    ctx.fillText('惊魂数：'+r.scares+(r.guardScares?'（吓跑保安 '+r.guardScares+' 次）':''),x+20,yy); yy+=26;
    ctx.fillText('被抓 / 散形：'+r.caught+' 次',x+20,yy); yy+=26;
    ctx.fillStyle='#ffd54a'; ctx.fillText('获得香火：'+r.xianghuo,x+20,yy);
    btn('again',x+20,y+420,(w-52)/2,54,'再来一夜',{bg:'#7a2a55',size:18});
    btn('title',x+32+(w-52)/2,y+420,(w-52)/2,54,'回标题',{bg:'#3d3266',size:18});
  }
  function star(cx,cy,r,on){ ctx.beginPath(); for (var i=0;i<10;i++){ var a=-Math.PI/2+i*Math.PI/5, rr2= i%2?r*0.45:r; ctx.lineTo(cx+Math.cos(a)*rr2, cy+Math.sin(a)*rr2); } ctx.closePath(); ctx.fillStyle=on?'#ffd54a':'#3a2f55'; ctx.fill(); ctx.strokeStyle='#120a20'; ctx.lineWidth=2.5; ctx.stroke(); }

  // ---------- 声音（WebAudio 合成，无外部文件）----------
  var AC=null, lastToastSeen=null;
  function ac(){ if (!AC){ try { AC=new (window.AudioContext||window.webkitAudioContext)(); } catch(e){ AC=null; } } if (AC && AC.state==='suspended') AC.resume(); return AC; }
  function tone(f,d,type,vol,f2,delay){ var a=AC; if(!a) return; try{ var t=a.currentTime+(delay||0), o=a.createOscillator(), g=a.createGain(); o.type=type||'sine'; o.frequency.setValueAtTime(f,t); if(f2) o.frequency.exponentialRampToValueAtTime(f2,t+d); g.gain.setValueAtTime(vol||0.08,t); g.gain.exponentialRampToValueAtTime(0.0001,t+d); o.connect(g); g.connect(a.destination); o.start(t); o.stop(t+d+0.02); }catch(e){} }
  function sfxFx(t){
    if (!AC) return;
    if (t.indexOf('完美')>=0){ tone(880,0.18,'triangle',0.08); tone(1320,0.25,'triangle',0.08,null,0.1); }
    else if (t.indexOf('惊恐')>=0){ tone(900,0.6,'sawtooth',0.04,300); }
    else if (t.indexOf('恐惧+')>=0){ tone(110,0.25,'sine',0.14,60); }
    else if (t.indexOf('疑心')>=0){ tone(300,0.12,'square',0.025,240); }
    else if (t.indexOf('神光')>=0 || t.indexOf('拿督公巡视')>=0){ tone(196,1.2,'sine',0.1); tone(294,1.2,'sine',0.05); }
    else if (t.indexOf('手电')>=0){ tone(1000,0.12,'square',0.04); tone(1000,0.12,'square',0.04,null,0.18); }
    else if (t.indexOf('RM')>=0 || t.indexOf('吃掉')>=0 || t.indexOf('私房钱')>=0 || t.indexOf('魂力+')>=0){ tone(1400,0.08,'square',0.03); tone(2100,0.12,'square',0.03,null,0.07); }
    else if (t.indexOf('不怕')>=0){ tone(220,0.2,'triangle',0.05,180); }
  }
  function sfxToast(m){ if (!AC) return;
    if (m.indexOf('铃声')>=0){ for (var i=0;i<3;i++) tone(1568,0.6,'triangle',0.05,null,i*0.35); }
    else if (m.indexOf('抓到')>=0 || m.indexOf('耗尽')>=0){ tone(330,0.3,'sawtooth',0.05,160); tone(160,0.5,'sawtooth',0.05,80,0.25); }
    else if (m.indexOf('完成')>=0){ tone(660,0.15,'triangle',0.07); tone(880,0.15,'triangle',0.07,null,0.12); tone(1320,0.3,'triangle',0.07,null,0.24); }
    else if (m.indexOf('搜捕')>=0){ tone(700,0.2,'square',0.04,500); tone(700,0.2,'square',0.04,500,0.25); }
  }

  // ---------- 开局 ----------
  function newNight(){
    save.seed=(save.seed||1)+1; writeSave();
    game=new S.Game(save.seed);
    window.__game=game;
    game.onFx=sfxFx; bakeStatic(); overview=false; camManual=0; paused=false;
    var g=game.ghosts[0]; cam.x=g.x-VW/cam.zDefault/2; cam.y=g.y-200;
    scene='play'; recorded=false;
    seenTip={0:1}; game.toast('今晚三张委托。饿鬼王闻得到全楼宵夜（金圈），点房间就会走过去。');
  }
  var recorded=false, seenTip={0:1};
  var GHOST_TIPS=['饿鬼王闻得到全楼的宵夜（金圈）。宵夜到时间会被住户吃掉，要赶。体型大，钻不了通风口和电梯井。',
    'Toyol 钻门缝和通风口，锁着的铁闸挡不住它，还能爬电梯井。金色硬币只有它看得到。身上钱越多飘得越慢。',
    '天花姐在天花夹层爬：盐挡不住，保安手电照不到。在房间上方按「吓」会倒挂吓人。下地太久会掉魂力。'];
  function onResult(){
    if (recorded) return; recorded=true;
    var r=game.result; save.nights++; save.best=Math.max(save.best,r.stars); save.xianghuo+=r.xianghuo; writeSave();
  }

  // ---------- 输入 ----------
  var ptr=null;
  cv.addEventListener('pointerdown',function(e){ ac(); var p=pt(e); ptr={x:p.x,y:p.y,sx:p.x,sy:p.y,drag:false,cx:cam.x,cy:cam.y}; });
  cv.addEventListener('pointermove',function(e){ if(!ptr) return; var p=pt(e); if (scene==='play' && !overview && ptr.sy>TOP && ptr.sy<VH-BOT){ if (Math.hypot(p.x-ptr.sx,p.y-ptr.sy)>10) ptr.drag=true; if (ptr.drag){ cam.x=ptr.cx-(p.x-ptr.sx)/cam.z; cam.y=ptr.cy-(p.y-ptr.sy)/cam.z; clampCam(); camManual=4; } } });
  cv.addEventListener('pointerup',function(e){ if(!ptr) return; var p=pt(e), was=ptr; ptr=null; if (!was.drag) tap(p.x,p.y); });
  function pt(e){ var r=cv.getBoundingClientRect(); return {x:e.clientX-r.left, y:e.clientY-r.top}; }
  function tap(x,y){
    for (var i=0;i<buttons.length;i++){ var b=buttons[i]; if (x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h){ press(b.id); return; } }
    if (scene!=='play' || paused) return;
    if (y<TOP || y>VH-BOT) return;
    var w=toWorld(x,y), G=game, gi=G.active, g=G.ghosts[gi];
    if (overview){ overview=false; cam.z=cam.zDefault; cam.x=w.x-VW/cam.z/2; cam.y=w.y-viewH()/cam.z/2; clampCam(); camManual=3; return; }
    // 点人
    var hit=null;
    G.residents.concat(G.guards).forEach(function(r){ if (r.state==='shower'&&!r.edge) return; if (Math.abs(w.x-r.x)<20 && w.y<r.y+4 && w.y>r.y-58) hit=r; });
    if (hit){
      g.target=hit; G.float(hit.x,hit.y-70,'选为目标','#ffd54a');
      if (hit.mode) return;
      var hn=GR.idx[hit.node];
      if (hn.lane==='room'){ var dest = g.id==='tianhua' ? 'E'+hn.room+hn.f+'_'+hn.u : hn.id; var cur=g.edge?null:g.node; if (cur!==dest) G.moveGhost(gi,dest); }
      return;
    }
    var nid=G.nodeForTap(gi,w.x,w.y);
    if (nid){ G.moveGhost(gi,nid); var n=GR.idx[nid]; tapMark={x:n.x,y:n.y-6,t:1}; camManual=0; }
  }
  function press(id){
    var G=game;
    if (id==='start'){ newNight(); return; }
    if (id==='again'){ newNight(); return; }
    if (id==='title'){ scene='title'; return; }
    if (scene!=='play') return;
    if (id==='overview'){ overview=!overview; if(!overview){ cam.z=cam.zDefault; camManual=0; } return; }
    if (id.indexOf('ghost')===0){ var i=+id.slice(5); G.active=i; camManual=0; overview=false;
      if (!seenTip[i]){ seenTip[i]=1; G.toast(GHOST_TIPS[i]); } return; }
    if (id==='finish'){ G.endNight(); return; }
    if (id==='pause'){ paused=!paused; return; }
    if (id==='scare') G.scarePress(G.active);
    if (id==='take') G.takePress(G.active);
    if (id==='hide') G.hidePress(G.active);
    if (id==='radio') G.radioPress(G.active);
  }

  // ---------- 主循环（限 30fps）----------
  var last=0, acc=0;
  function frame(ts){
    requestAnimationFrame(frame);
    if (!last) last=ts; var dt=(ts-last)/1000; if (dt<1/31) return; last=ts; dt=Math.min(dt,0.1);
    animT+=dt;
    if (tapMark) tapMark.t-=dt*1.5;
    if (scene==='title'){ drawTitle(); return; }
    if (scene==='play'){
      if (!game.over && !paused){ var steps=Math.ceil(dt/(1/30)); for (var i=0;i<steps;i++) game.update(dt/steps); }
      updateCam(dt);
      screenT(); ctx.fillStyle='#120a26'; ctx.fillRect(0,0,VW,VH);
      drawWorld(); drawUI();
      if (paused){ screenT(); ctx.fillStyle='rgba(10,5,22,0.55)'; ctx.fillRect(0,TOP,VW,viewH()); ctx.fillStyle='#fff'; ctx.font='bold 26px '+FONT; ctx.textAlign='center'; ctx.fillText('暂停中',VW/2,TOP+viewH()/2); ctx.font='14px '+FONT; ctx.fillText('按「继续」回到这一夜',VW/2,TOP+viewH()/2+28); }
      if (game.lastToast && game.lastToast!==lastToastSeen){ lastToastSeen=game.lastToast; sfxToast(game.lastToast.msg); }
      if (game.over){ onResult(); drawResult(); }
    }
  }
  window.addEventListener('resize',resize);
  resize();
  loadImages(function(){ requestAnimationFrame(frame); });
  window.__lyg={press:press, tap:tap, get game(){return game;}, get cam(){return cam;}, toScreen:function(x,y){return toScreen(x,y);}, setOverview:function(v){overview=v;}};
})();
