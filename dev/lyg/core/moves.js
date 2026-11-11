  // ---------- 三隻鬼嘅招式：預兆 → 出手 → 餘痕（民間依據見審閱頁） ----------
  var MV={
    eking:{n:'碗筷自己郁・米缸巨口', omen:'叮叮噹噹……', tr:'food'},
    toyol:{n:'細腳印・床底搶嘢', omen:'嘻嘻……嘻嘻……', tr:'mess'},
    tianhua:{n:'天花滲水・倒吊貼面', omen:'嘀……嘀……', tr:'hair'}
  };
  var OMEN=0.75, STRIKE=0.65, AFTER=0.6;
  var REACT={
    scream:['啊——！！','嘩呀——！！','救——命——！'], kneel:['唔好搵我……我冇做壞事㗎','放過我啦……','我同你無仇無怨㗎……'],
    cover:['睇唔到睇唔到睇唔到……','唔好望唔好望……'], fall:['哎呀！','跌親呀——'],
    phone:['喂？管理處呀！有嘢呀！','喂喂喂！快啲上嚟！'], slipper:['打死你！打死你！','睇我隻拖鞋！'], push:['你行先！','唔好推我呀！']
  };
  function startMove(g,r,un){
    g.scareCd=OMEN+STRIKE+AFTER+0.3; g.dir=r.x>g.x?1:-1;
    var ceil=fy(un.f+1)+16, side=(r.x-un.rx[0]<(un.rx[1]-un.rx[0])/2)?1:-1;
    g.sc={t:0,r:r,un:un,k:g.d.key,hit:false,tr:false,ceil:ceil,side:side,sx:r.x+side*42};
    float(g.x,g.y-g.d.h-18,MV[g.d.key].n,'#ffb7a0');
  }
  function moveUpdate(g,dt){
    var S=g.sc; if (!S) return;
    if (S.t<OMEN && (g.to||g.mv>0.05)){ float(g.x,g.y-80,'一郁就破功','#ffd54a'); g.sc=null; g.scareCd=0.4; return; }
    var t0=S.t; S.t+=dt; var r=S.r, k=S.k;
    if (S.t<OMEN){ // 預兆粒子
      if (k==='tianhua' && rnd()<dt*9) part(r.x+(rnd()-0.5)*30,S.ceil+4,0,30,0.8,'drip');
      if (k==='toyol' && Math.floor(S.t*8)!==Math.floor(t0*8)){ var q=Math.floor(S.t*8); (S.prints=S.prints||[]).push({x:S.sx+(r.x-S.sx)*q/6+(q%2?4:-4),y:r.y-2}); }
    }
    if (!S.hit && S.t>=OMEN){ S.hit=true; G.shake=0.35; g.actT=0;
      if (k==='toyol'){ for (var q=0;q<6;q++){ var p={x:r.x,y:r.y-34,vx:0,vy:0,life:0.9,max:0.9,type:'note'}; p.tx=S.sx; p.ty=r.y-14; G.parts.push(p); } }
      if (k==='eking'){ for (var q=0;q<8;q++) part(S.sx,r.y-30,(rnd()-0.5)*160,-80-rnd()*60,0.8,'crumb'); }
      if (k==='tianhua'){ for (var q=0;q<10;q++) part(r.x,r.y-50,(rnd()-0.5)*80,-20,0.7,'drip'); }
      scareRes(r,38,g); }
    if (!S.tr && S.t>=OMEN+STRIKE){ S.tr=true; addTrace(MV[k].tr,S,g); }
    if (S.t>=OMEN+STRIKE+AFTER) g.sc=null;
  }
  function addTrace(kind,S,g){ var un=S.un;
    var T={k:kind,f:un.f,un:un,x:kind==='hair'?un.x:S.r.x,y:fy(un.f),life:kind==='hair'?40:22,used:false,t:0};
    G.traces.push(T);
    if (kind==='mess'){ G.alert+=1; float(un.x,un.y-96,'翻箱倒櫃好嘈！全樓警覺 +1','#ffb0b0'); checkAlert();
      var best=null,bd=1e9; G.guards.forEach(function(h){ if (h.kind!=='guard'||h.state==='flee') return; var hf=G.nodes[h.node].f; var d=Math.abs(hf-un.f)*400+Math.abs(h.x-un.x); if (d<bd){bd=d;best=h;} });
      if (best){ best.state='chase'; best.alertT=1.2; best.say='邊度咁嘈？上去睇睇！'; best.sayT=2.4; }
      if (S.r.state==='home'){ S.r.hunt=4; say(S.r,pick(['我啲錢呢？！','銀包去咗邊呀？！','邊個翻亂晒啲嘢？'])); } }
    if (kind==='food') T.wait=3.2;
    if (kind==='hair') float(un.x,un.y-96,'門框留低濕頭髮……','#9fe0ff');
  }
  function traceUpdate(dt){
    G.traces.forEach(function(T){ T.life-=dt; T.t+=dt;
      if (T.k==='food' && !T.used){ var r=T.un.res;
        if (r && r.state==='home'){ T.wait-=dt; if (T.wait<=0){ T.used=true; say(r,'邊個搞到成地都係飯……'); r.tidy=1.2; r.tidyCb=function(){ r.jumpT=0.5; say(r,'嘩！碗入面有隻眼！'); scareRes(r,30,null); addFear(6,r.x,r.y-90); float(r.x,r.y-110,'二次嚇！','#ff7a5a'); }; } }
        else G.guards.forEach(function(h){ if (T.used||h.state==='flee'||h.kind==='dog') return; if (G.nodes[h.node].f!==T.f||Math.abs(h.x-T.x)>26) return; T.used=true; h.wait=1.6; h.to=null; h.say='成地都係飯……咦？碗郁咗！'; h.sayT=2.2; h.alertT=1; addFear(6,h.x,h.y-90); float(h.x,h.y-110,'二次嚇！','#ff7a5a'); }); }
      if (T.k==='hair' && !T.used){ var vic=null;
        G.guards.forEach(function(h){ if (!vic&&h.state!=='flee'&&h.kind!=='dog'&&Math.abs(h.y-T.y)<30&&Math.abs(h.x-T.x)<18) vic=h; });
        G.res.forEach(function(r){ if (!vic&&r.state==='flee'&&Math.abs(r.y-T.y)<30&&Math.abs(r.x-T.x)<18) vic=r; });
        if (vic){ T.used=true; T.life=Math.min(T.life,2.5); vic.tangle=2.2; if (vic.state==='flee'){ vic.tripT=1.2; } else { vic.wait=2.2; vic.to=null; vic.path=null; } vic.say='咩嘢纏住我隻腳呀？！濕㗎！'; vic.sayT=2.2; addFear(6,vic.x,vic.y-90); float(vic.x,vic.y-112,'濕髮纏腳！','#9fe0ff'); } }
    });
    G.traces=G.traces.filter(function(T){return T.life>0;});
    G.res.forEach(function(r){
      if (r.hunt>0){ r.hunt-=dt; if (r.state==='home'){ r.fear+=dt*5; if (r.fear>=100) flee(r,null); } }
      if (r.tidy>0){ r.tidy-=dt; if (r.tidy<=0&&r.tidyCb){ var cb=r.tidyCb; r.tidyCb=null; cb(); } }
      if (r.react){ r.react.t-=dt; if (r.react.t<=0) r.react=null; }
      if (r.fleeAfter>0){ r.fleeAfter-=dt; if (r.fleeAfter<=0 && r.state==='home'){ r.fleeAfter=0; flee(r,r.fleeG); } }
    });
    G.guards.forEach(function(h){ if (h.tangle>0) h.tangle-=dt; });
  }
  function pickReact(r,g){
    if (r.brave) return 'slipper';
    var opts=['scream','kneel','cover','fall','phone'];
    var near=G.guards.concat(G.res).some(function(o){ return o!==r && o.state!=='flee' && o.state!=='gone' && Math.abs(o.y-r.y)<30 && Math.abs(o.x-r.x)<130; });
    if (near) opts.push('push','push');
    var k=pick(opts); if (k===r.lastReact) k=pick(opts); r.lastReact=k; return k;
  }
  function doReact(r,g){ var k=pickReact(r,g); r.react={k:k,t:1.7}; say(r,pick(REACT[k]));
    if (k==='phone'){ G.alert+=1; float(r.x,r.y-100,'打電話求救！警覺 +1','#ffb0b0'); }
    if (k==='slipper'&&g){ g.bounceT=0.45; float(g.x,g.y-g.d.h-6,'拖鞋打空氣','#e8d8b0'); }
    if (k==='push'){ var o=null; G.guards.concat(G.res).forEach(function(q){ if (!o&&q!==r&&q.state!=='flee'&&q.state!=='gone'&&Math.abs(q.y-r.y)<30&&Math.abs(q.x-r.x)<130) o=q; }); if (o){ r.pushTo=o.x>r.x?1:-1; o.jumpT=0.5; if (o.unit){ o.fear+=10; } else { o.wait=Math.max(o.wait||0,0.9); } } }
  }
  // 綠豆 / 玩具：馬來民間話放一兜綠豆，Toyol 會忍唔住坐低逐粒數
  function setupBeans(){ if (G.beansInit) return; G.beansInit=true; var c=0;
    G.units.forEach(function(u){ if (c<2 && u.res && u.ot!=='deity' && u.f>0 && (u.f+u.u)%2===1){ u.beans=true; c++; } });
    if (!c){ var u=G.units.find(function(u){return u.res&&u.ot!=='deity';}); if (u) u.beans=true; } }
  var COUNT=['一','二','三','四','五','六','七','八','九','十'];
  function beansCheck(g,dt){ if (g.d.key!=='toyol') return; var n=G.nodes[g.node];
    if (g.countT>0){ g.countT-=dt; g.cntAcc=(g.cntAcc||0)+dt; if (g.cntAcc>0.26){ g.cntAcc=0; g.cntN=(g.cntN||0)+1; float(g.x+(rnd()-0.5)*16,g.y-g.d.h-4,COUNT[(g.cntN-1)%10]+'……','#b8f0a0'); } return; }
    if (n.kind==='in' && !g.to){ var un=unitOf(n.id); if (un.beans && !un.beansDone){ un.beansDone=true; g.countT=2.6; g.stun=2.6; g.cntN=0; g.taskP=0; g.sc=null; float(g.x,g.y-g.d.h-20,'地下有綠豆！忍唔住坐低數……','#b8f0a0'); } } }

  // ---------- 畫招式 ----------
  function drawBowl(x,y,fill){ ctx.fillStyle='#d8d0c0'; ctx.beginPath(); ctx.moveTo(x-9,y-6); ctx.quadraticCurveTo(x,y+5,x+9,y-6); ctx.closePath(); ctx.fill(); ctx.strokeStyle='#6a4a2a'; ctx.lineWidth=1; ctx.stroke(); if (fill>0){ ctx.fillStyle='#f0e6c8'; ctx.beginPath(); ctx.ellipse(x,y-6,8*fill,2.6,0,0,7); ctx.fill(); } }
  function drawMouth(x,y,R,open,dir){ ctx.save(); ctx.translate(x,y); ctx.scale(dir,1);
    ctx.fillStyle='#120808'; ctx.beginPath(); ctx.ellipse(0,0,R*1.1,R*0.85,0,0,7); ctx.fill();
    ctx.fillStyle='#7a0e0e'; ctx.beginPath(); ctx.ellipse(R*0.15,0,R*0.85,R*0.62*open+2,0,0,7); ctx.fill();
    ctx.fillStyle='#e8e0cc'; var n=7; for (var i=0;i<n;i++){ var tx=-R*0.65+i*R*1.6/n; ctx.beginPath(); ctx.moveTo(tx,-R*0.62*open); ctx.lineTo(tx+R*0.11,-R*0.62*open+R*0.28); ctx.lineTo(tx+R*0.22,-R*0.62*open); ctx.fill(); ctx.beginPath(); ctx.moveTo(tx,R*0.62*open); ctx.lineTo(tx+R*0.11,R*0.62*open-R*0.26); ctx.lineTo(tx+R*0.22,R*0.62*open); ctx.fill(); }
    ctx.fillStyle='#d0c060'; ctx.beginPath(); ctx.arc(-R*0.55,-R*0.9,R*0.12,0,7); ctx.arc(R*0.35,-R*0.95,R*0.12,0,7); ctx.fill(); ctx.restore(); }
  function txt(s,x,y,c,sz){ ctx.font='bold '+(sz||12)+'px '+FONT; ctx.textAlign='center'; ctx.lineWidth=3; ctx.strokeStyle='#000'; ctx.strokeText(s,x,y); ctx.fillStyle=c; ctx.fillText(s,x,y); }
  function drawMoves(){
    G.gh.forEach(function(g){ var S=g.sc; if (!S||g.home||g.out) return; var r=S.r, un=S.un, top=fy(un.f+1)+10, flo=fy(un.f), k=S.k, t=S.t;
      ctx.save(); ctx.beginPath(); ctx.rect(un.rx[0]-40,top,un.rx[1]-un.rx[0]+80,flo-top+2); ctx.clip();
      if (t<OMEN){ var o=t/OMEN;
        if (k==='eking'){ for (var i=0;i<3;i++){ var bx=r.x-S.side*(14+i*14), by=r.y-22-Math.abs(Math.sin(G.t*18+i*2))*7*o; ctx.save(); ctx.translate(bx,by); ctx.rotate(Math.sin(G.t*22+i)*0.35*o); drawBowl(0,0,1); ctx.restore(); ctx.strokeStyle='#c8a050'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.moveTo(bx+6,by-8-Math.sin(G.t*30+i)*4); ctx.lineTo(bx+14,by-18); ctx.stroke(); }
          txt(MV.eking.omen,r.x-S.side*28,r.y-72-o*6,'#ffe9a0',11); }
        if (k==='toyol'){ (S.prints||[]).forEach(function(p,i){ ctx.fillStyle='rgba(120,200,150,'+(0.55)+')'; ctx.beginPath(); ctx.ellipse(p.x,p.y,2.6,1.5,0,0,7); ctx.fill(); ctx.beginPath(); ctx.ellipse(p.x+3,p.y-3,1,1,0,0,7); ctx.fill(); });
          ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); ctx.fillStyle='#7a6a5a'; ctx.fillRect(S.sx-28,flo-24,56,7);
          txt(MV.toyol.omen,S.sx,flo-36-Math.sin(G.t*9)*3,'#b8f0a0',11); }
        if (k==='tianhua'){ ctx.fillStyle='rgba(60,90,110,'+(0.55*o)+')'; ctx.beginPath(); ctx.ellipse(r.x,S.ceil+2,10+o*26,4+o*4,0,0,7); ctx.fill();
          txt(MV.tianhua.omen,r.x+22,S.ceil+22,'#9fe0ff',11); }
      } else if (t<OMEN+STRIKE){ var s=(t-OMEN)/STRIKE, e=s<0.35?s/0.35:1;
        if (k==='eking'){ ctx.fillStyle='#2a2e32'; ctx.fillRect(S.sx-15,flo-60,30,58); ctx.strokeStyle='#8a9aa0'; ctx.lineWidth=1.5; ctx.strokeRect(S.sx-15,flo-60,30,58); ctx.beginPath(); ctx.moveTo(S.sx-15,flo-38); ctx.lineTo(S.sx+15,flo-38); ctx.stroke();
          ctx.fillStyle='rgba(255,240,200,'+(0.5*e)+')'; ctx.fillRect(S.sx-15,flo-60,4,58);
          drawMouth(S.sx+(r.x-S.sx)*0.45*e,flo-40,10+28*e,0.35+0.65*Math.abs(Math.sin(s*Math.PI*3)),r.x>S.sx?1:-1); }
        if (k==='toyol'){ ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); spr('toyol',S.sx+(r.x-S.sx)*0.4*e,flo-6+18*(1-e),40,{flip:r.x<S.sx,rot:(r.x>S.sx?1:-1)*0.3*(1-e)}); ctx.fillStyle='#7a6a5a'; ctx.fillRect(S.sx-28,flo-24,56,7);
          if (s>0.3) txt('搶咗！',S.sx,flo-62,'#ffd54a',13); }
        if (k==='tianhua'){ var yb=S.ceil+8+(r.y-30-S.ceil-8)*e, hx=r.x+(r.x>g.x?-14:14); ctx.strokeStyle='rgba(14,14,18,0.9)'; ctx.lineWidth=1.6; for (var i=0;i<10;i++){ ctx.beginPath(); ctx.moveTo(hx-12+i*2.6,S.ceil); ctx.quadraticCurveTo(hx-12+i*2.6+Math.sin(G.t*6+i)*3,(S.ceil+yb)/2,hx-14+i*3,yb-20); ctx.stroke(); }
          spr('tianhua_hang',hx,yb,74,{flip:r.x<g.x,rot:Math.sin(G.t*4)*0.05}); for (var i=0;i<3;i++){ ctx.fillStyle='#9fe0ff'; ctx.beginPath(); ctx.arc(hx-8+i*8,yb+4+((G.t*60+i*9)%22),1.8,0,7); ctx.fill(); } }
      } else { var a=1-(t-OMEN-STRIKE)/AFTER;
        if (k==='eking'){ ctx.globalAlpha=a; ctx.fillStyle='#2a2e32'; ctx.fillRect(S.sx-15,flo-60,30,58); ctx.globalAlpha=1; }
        if (k==='toyol'){ ctx.globalAlpha=a; ctx.fillStyle='#3a2a1e'; ctx.fillRect(S.sx-26,flo-18,52,10); ctx.globalAlpha=1; }
      }
      ctx.restore(); });
  }
  function drawTraces(){
    G.traces.forEach(function(T){ var a=Math.min(1,T.life/2); ctx.globalAlpha=a;
      if (T.k==='food'){ for (var i=0;i<9;i++){ var px=T.x-26+((i*37)%52), py=T.y-3-(i%3); ctx.fillStyle=i%3?'#e8d8a0':'#c8784a'; ctx.beginPath(); ctx.ellipse(px,py,3+(i%2)*2,1.6,0,0,7); ctx.fill(); }
        ctx.save(); ctx.translate(T.x+10,T.y-6); ctx.rotate(1.3); drawBowl(0,0,0); ctx.restore(); ctx.save(); ctx.translate(T.x-18,T.y-5); ctx.rotate(-2.2); drawBowl(0,0,0); ctx.restore();
        ctx.strokeStyle='#c8a050'; ctx.lineWidth=1.4; ctx.beginPath(); ctx.moveTo(T.x-4,T.y-2); ctx.lineTo(T.x+14,T.y-5); ctx.moveTo(T.x-2,T.y-1); ctx.lineTo(T.x+12,T.y+1); ctx.stroke();
        var r=T.un.res; if (r&&r.tidy>0){ txt('執緊……',r.x,r.y-80,'#e8d8b0',11); } }
      if (T.k==='mess'){ for (var i=0;i<10;i++){ var px=T.x-34+((i*29)%68), py=T.y-3-(i%2)*2; ctx.save(); ctx.translate(px,py); ctx.rotate(i*0.7); ctx.fillStyle=i%2?'#e8e2d0':'#9cc89c'; ctx.fillRect(-4,-2.5,8,5); ctx.restore(); }
        ctx.fillStyle='#4a3424'; ctx.save(); ctx.translate(T.x+24,T.y-8); ctx.rotate(0.5); ctx.fillRect(-10,-5,20,10); ctx.restore(); if (T.t<4) txt('乒乒乓乓',T.x,T.y-84-Math.sin(G.t*14)*2,'#ffb0b0',11); }
      if (T.k==='hair'){ var top=fy(T.f+1)+16; ctx.strokeStyle=T.used?'rgba(30,30,36,0.5)':'rgba(20,22,28,0.92)'; ctx.lineWidth=1.4; for (var i=0;i<8;i++){ var hx=T.x-14+i*1.6+(i>3?24:0); ctx.beginPath(); ctx.moveTo(hx,top+4); ctx.quadraticCurveTo(hx+Math.sin(G.t*2+i)*4,top+30,hx+Math.sin(G.t*1.5+i)*3,top+44+i%3*8); ctx.stroke(); }
        if (!T.used){ ctx.fillStyle='rgba(159,224,255,0.7)'; ctx.beginPath(); ctx.arc(T.x-10,top+50+((G.t*40)%24),1.6,0,7); ctx.fill(); } }
      ctx.globalAlpha=1; });
    G.units.forEach(function(u){ if (!u.beans||!u.open) return; var cx=(u.rx[0]+u.rx[1])/2+18, y=u.y-3; for (var i=0;i<16;i++){ ctx.fillStyle=u.beansDone?'#5a7a3a':'#7ac04a'; ctx.beginPath(); ctx.arc(cx-16+((i*13)%32),y-(i%3)*1.4,1.7,0,7); ctx.fill(); }
      ctx.fillStyle='#d24a3a'; ctx.beginPath(); ctx.arc(cx+20,y-4,4,0,7); ctx.fill(); ctx.fillStyle='#ffd54a'; ctx.fillRect(cx+24,y-8,6,6);
      if (u.seen) txt(u.beansDone?'綠豆（數過）':'綠豆・玩具',cx,y-14,'#b8f0a0',10); });
  }
  // 住戶反應姿勢（畫 sprite 前調整）
  function reactPose(r,P){ var R=r.react; if (!R||r.state!=='home') return; var q=1-R.t/1.7;
    if (R.k==='scream'){ P.sh=Math.sin(G.t*50)*2.4; P.jy=-Math.abs(Math.sin(q*Math.PI*2))*8; }
    if (R.k==='kneel'){ P.sy=0.66; P.jy=2; P.ro=Math.sin(G.t*6)*0.05; }
    if (R.k==='cover'){ P.sy=0.86; P.sh=Math.sin(G.t*30)*1.4; P.hands=true; }
    if (R.k==='fall'){ P.ro=(r.x<300?-1:1)*Math.min(1.35,q*5); P.jy=Math.min(1,q*5)*10; }
    if (R.k==='phone'){ P.phone=true; P.sh=Math.sin(G.t*20)*1; }
    if (R.k==='slipper'){ P.slip=true; P.ro=Math.sin(G.t*16)*0.12; }
    if (R.k==='push'){ P.ro=(r.pushTo||1)*0.3*Math.abs(Math.sin(G.t*10)); P.sh=(r.pushTo||1)*Math.abs(Math.sin(G.t*10))*8; }
    if (r.tidy>0){ P.sy=0.78; P.ro=0.25; }
  }
  function reactProps(r,P){ var R=r.react; if (!R||r.state!=='home') return;
    if (P.hands){ ctx.fillStyle='#e8c0a0'; ctx.beginPath(); ctx.arc(r.x-8,r.y-46,5,0,7); ctx.arc(r.x+8,r.y-46,5,0,7); ctx.fill(); }
    if (P.phone){ ctx.fillStyle='#202428'; ctx.fillRect(r.x+9,r.y-50,6,11); ctx.fillStyle='#9fe0ff'; ctx.fillRect(r.x+10,r.y-49,4,7); for (var i=0;i<2;i++){ ctx.strokeStyle='rgba(159,224,255,'+(0.8-i*0.3)+')'; ctx.lineWidth=1.5; ctx.beginPath(); ctx.arc(r.x+12,r.y-45,9+i*6+((G.t*20)%5),-0.8,0.8); ctx.stroke(); } }
    if (P.slip){ var a=Math.sin(G.t*16)*1.2; ctx.save(); ctx.translate(r.x,r.y-42); ctx.rotate(a); ctx.fillStyle='#3a6ad0'; ctx.fillRect(14,-4,16,7); ctx.restore(); ctx.strokeStyle='rgba(255,255,255,0.5)'; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(r.x,r.y-42,26,-1.2,1.2); ctx.stroke(); }
    if (R.k==='scream'){ ctx.strokeStyle='rgba(255,255,255,0.75)'; ctx.lineWidth=2; for (var i=0;i<3;i++){ var an=-2.2+i*0.6; ctx.beginPath(); ctx.moveTo(r.x+Math.cos(an)*24,r.y-46+Math.sin(an)*24); ctx.lineTo(r.x+Math.cos(an)*34,r.y-46+Math.sin(an)*34); ctx.stroke(); var an2=-0.95+i*0.6; ctx.beginPath(); ctx.moveTo(r.x+Math.cos(an2)*24,r.y-46+Math.sin(an2)*24); ctx.lineTo(r.x+Math.cos(an2)*34,r.y-46+Math.sin(an2)*34); ctx.stroke(); } }
  }
  // 鬼嘅讀條道具
  function drawTaskProps(o,by){ if (!(o.taskP>0)) return; var n=G.nodes[o.node]; if (n.kind!=='in') return; var k=o.d.key, d=o.dir, p=o.taskP;
    if (k==='eking'){ var bx=o.x+d*36, byy=o.y-14; drawBowl(bx,byy,1-p); var mx=o.x+d*6, my=by-o.d.h*0.6; ctx.strokeStyle='#5a3a2c'; ctx.lineWidth=3.2; ctx.beginPath(); ctx.moveTo(mx,my); ctx.quadraticCurveTo(o.x+d*30,my-16+Math.sin(G.t*6)*3,bx,byy-6); ctx.stroke(); ctx.strokeStyle='#8a5a44'; ctx.lineWidth=1.4; ctx.stroke();
      var q=(G.t*2.2)%1, qx=bx+(mx-bx)*q, qy=(byy-6)+(my-byy+6)*q-Math.sin(q*Math.PI)*14; ctx.fillStyle='#f0e6c8'; ctx.beginPath(); ctx.arc(qx,qy,3.2,0,7); ctx.fill(); }
    if (k==='toyol'){ var dx=o.x+d*30, dy=o.y-34, out=6+Math.abs(Math.sin(G.t*7))*8; ctx.fillStyle='#4a3424'; ctx.fillRect(dx-16,dy-10,32,26); ctx.fillStyle='#6a4a30'; ctx.fillRect(dx-14+d*out,dy-6,28,10); ctx.fillStyle='#c8a050'; ctx.fillRect(dx-2+d*out,dy-2,4,2); }
    if (k==='tianhua'){ var mx=o.x+d*34, my=o.y-62; ctx.fillStyle='#c8a050'; ctx.fillRect(mx-13,my-20,26,40); ctx.fillStyle='#1a2a30'; ctx.fillRect(mx-10,my-17,20,34); ctx.save(); ctx.beginPath(); ctx.rect(mx-10,my-17,20,34); ctx.clip(); spr('tianhua',mx,my+20,40,{flip:d>0,alpha:Math.min(0.9,p*2.6)}); ctx.restore(); ctx.fillStyle='rgba(220,245,255,0.25)'; ctx.fillRect(mx-10,my-17,5,34);
      var cy=by-o.d.h*0.8+((G.t*40)%(o.d.h*0.5)); ctx.fillStyle='#d8b878'; ctx.fillRect(o.x-d*10-5,cy,10,3); }
  }
