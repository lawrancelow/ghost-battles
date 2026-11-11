# patch_v8_tiles：由 patch_v5.py 引用；def patch(s) 收 pangsa.js 字串、回傳改好嘅字串
# 大樓剖面改用新格（gen_art/gb_tower_tiles2.jpg → gb/tools/port_tower_tiles.py → SPR['twt_*']）：
#   走廊（corr1/corr2）、樓梯（stairR 由左下上右上／stairL 由右下上左上）、電梯井（lift）、天台（roof）、地下大堂（lobby）、地庫停車場（carpark）
#   住戶房間圖（room_mahjong 等）保持唔變；冇新格（lyg 獨立版未載入）就行返舊嘅剪貼砌法。
#   老店屋：住戶單位同地下舖頭保持舊店屋圖（新走廊／大堂格係組屋款，唔啱店屋），只換樓梯、地庫、天台。
TILES = r"""
    // ===== v8：新剖面格（twt_*）。回傳 false＝冇圖，行返舊砌法 =====
    function bakeTiles(){
      function TI(k){ var im=IMG['twt_'+k]||(typeof SPR!=='undefined'?SPR['twt_'+k]:null); return im&&(im.naturalWidth||im.width)?im:null; }
      var T={}, ok=true; ['corr1','corr2','stairR','stairL','lift','roof','lobby','carpark'].forEach(function(k){ T[k]=TI(k); if (!T[k]) ok=false; }); if (!ok) return false;
      var N=416, FLY={corr1:400,corr2:400,stairR:398,stairL:398,lift:403,roof:402,lobby:405,carpark:405};   // 每格地台前緣喺原圖第幾行（對準 fy(f)+3）
      var KK=LV.key==='shop'?2:1, SHOP=LV.key==='shop', BT='rgba(10,20,40,0.34)';
      function hs(a,b,d){ var h=Math.imul(a+1,73856093)^Math.imul(b+7,19349663)^Math.imul(d+3,83492791); h=Math.imul(h^(h>>>13),1274126177); return (h^(h>>>16))>>>0; }   // 固定 seed：每次開局都一樣
      // 將格圖 [sx0,sx1]×[sy0,底] 貼去 [x0,x0+w]；sy0 行對 top、FLY 行對 floor
      function tile(k,sx0,sx1,sy0,x0,w,top,floor,flip,tint){ var im=T[k], q=(im.naturalWidth||im.width)/N, s=(floor-top)/(FLY[k]-sy0), h=(N-sy0)*s;
        c.save(); if (flip){ c.translate(x0+w,0); c.scale(-1,1); c.drawImage(im,sx0*q,sy0*q,(sx1-sx0)*q,(N-sy0)*q,0,top,w,h); } else c.drawImage(im,sx0*q,sy0*q,(sx1-sx0)*q,(N-sy0)*q,x0,top,w,h); c.restore();
        if (tint){ c.fillStyle=tint; c.fillRect(x0,top,w,h); } }
      var RM={mahjong:'room_mahjong',gamer:'room_gamer',nurse:'room_nurse',helper:'room_helper',gym:'room_gym',shopper:'room_shopper'};
      var resPool=B.src.res, gPool=B.src.ground, ui=0;
      for (var f=0;f<FL;f++){ var top=fy(f+1), floor=fy(f)+3, bot=fy(f)+12, hgt=bot-top, c2prev=false;
        LV.xs.forEach(function(col,ci){ var x0=col[0], w=col[1]-col[0], kd=col[2], h0=hs(KK,f,ci), tn=f===0?BT:null;
          // 樓梯：兩邊樓梯都係向大樓內側行上（上到上一層就係走廊）；老店屋中間樓梯逐層調頭（之字形）
          if (kd==='stair'||kd==='back'||(kd==='lift'&&!LV.lift)){
            if (kd==='back'&&f===0&&!G.nodes['f0_b']){ tile('carpark',296,N,0,x0,w,top,floor,false,'rgba(10,20,40,0.16)'); return; }   // 組屋後樓梯唔落地庫：補停車場柱位
            var up=kd==='stair'?'R':kd==='back'?'L':(f%2?'L':'R');
            if (up==='R') tile('stairR',62,N,0,x0,w,top,floor,false,tn); else tile('stairL',0,354,0,x0,w,top,floor,false,tn); return; }
          if (kd==='lift'){ tile('lift',58,360,f===FL-1?0:46,x0,w,top,floor,false,tn); return; }   // 頂層先見到滑輪；𨋢門／轎廂由 core/lift.js 疊喺上面
          var un=G.units.find(function(q){return q.f===f&&q.rx[0]===x0;}), deity=un&&un.ot==='deity', rk=un&&!deity&&f>=1?RM[un.hh]:null, ri=rk&&IMG[rk];
          if (f===0){ tile('carpark',0,N,0,x0,w,top,floor,(h0>>>5)&1,'rgba(10,20,40,0.16)'); c2prev=false; return; }
          if (ri&&ri.width){ c.save(); if ((ci+f)%2===1){ c.translate(x0+w,top); c.scale(-1,1); c.drawImage(ri,0,0,w,hgt); } else c.drawImage(ri,x0,top,w,hgt); c.restore(); c.strokeStyle='rgba(0,0,0,0.6)'; c.lineWidth=3; c.strokeRect(x0+1,top+1,w-2,hgt-2); c2prev=false; return; }
          if (SHOP){ var r=deity?B.src.deity[0]:f===1?gPool[(ci+f)%gPool.length]:resPool[(ui++*5+f)%resPool.length]; put(r,x0,top,w,hgt,(ci+f)%2===1,null); return; }   // 老店屋：保留舊店屋圖
          if (f===1){ tile('lobby',0,N,0,x0,w,top,floor,ci%2===1,null); return; }   // 組屋地下：一格格 void deck
          // 組屋住宅層：走廊格（corr1 有門有閘、corr2 晾衫位），corr2 唔會連續兩格；corr1 鐵閘對準門口
          var two=!deity&&!c2prev&&(h0%100)<40; c2prev=two;
          if (two) tile('corr2',0,N,0,x0,w,top,floor,(h0>>>7)&1,null);
          else { tile('corr1',0,N,0,x0,w,top,floor,un?un.u%2===0:((h0>>>7)&1),null);
            if (deity){ c.fillStyle='rgba(110,8,8,0.20)'; c.fillRect(x0,top,w,floor-top); var dx=un.x;   // 神明戶：鐵閘貼滿紅紙
              for (var p=0;p<7;p++){ var px=dx-15+((h0>>>(p*3))&7)*4.3, py=fy(f)-92+((h0>>>(p*2+5))&7)*9+p*3; c.save(); c.translate(px,py); c.rotate((((h0>>>(p+9))&7)-3.5)*0.05); c.fillStyle=p%3?'#9e1e1a':'#c0281f'; c.fillRect(-4.5,-10,9,20); c.fillStyle='rgba(30,0,0,0.35)'; c.fillRect(2.5,-10,2,20); c.fillStyle='rgba(240,200,90,0.6)'; c.fillRect(-2,-6,4,1.4); c.fillRect(-2,-1,4,1.4); c.fillRect(-2,4,4,1.4); c.restore(); } } }
        }); }
      // 天台：天台格同佢左邊（天線＋機房）輪流排，每段左邊漸變疊上一段，冇硬接縫
      var rs=(fy(FL)+3+8)/FLY.roof, rh=N*rs, rtop=fy(FL)+3-FLY.roof*rs, x=0, i=0, F=30, im=T.roof, q=(im.naturalWidth||im.width)/N;
      while (x<WW){ var A=i%2===1, sx1=A?196:N, w=sx1*rs, flip=A?((hs(KK,99,i)>>>3)&1):((i>>1)%2===1);
        var oc=document.createElement('canvas'); oc.width=Math.max(1,Math.ceil(w*SC)); oc.height=Math.max(1,Math.ceil(rh*SC)); var ox=oc.getContext('2d');
        if (flip){ ox.translate(oc.width,0); ox.scale(-1,1); } ox.drawImage(im,0,0,sx1*q,N*q,0,0,oc.width,oc.height); ox.setTransform(1,0,0,1,0,0);
        if (i>0){ ox.globalCompositeOperation='destination-in'; var gr=ox.createLinearGradient(0,0,F*SC,0); gr.addColorStop(0,'rgba(0,0,0,0)'); gr.addColorStop(1,'rgba(0,0,0,1)'); ox.fillStyle=gr; ox.fillRect(0,0,oc.width,oc.height); }
        c.drawImage(oc,x,rtop,w,rh); x+=w-F; i++; }
      // 遮縫：每格之間一條柱影、每塊樓板底一層天花陰影、兩邊外牆暗角
      for (var f=0;f<FL;f++){ var top=fy(f+1), floor=fy(f)+10;
        LV.xs.forEach(function(col,ci){ if (!ci) return; var xb=col[0], g=c.createLinearGradient(xb-8,0,xb+8,0); g.addColorStop(0,'rgba(0,0,0,0)'); g.addColorStop(0.5,'rgba(0,0,0,0.58)'); g.addColorStop(1,'rgba(0,0,0,0)'); c.fillStyle=g; c.fillRect(xb-8,top,16,floor-top); }); }
      for (var f=0;f<=FL;f++){ var yb=fy(f)+3, g=c.createLinearGradient(0,yb,0,yb+26); g.addColorStop(0,'rgba(0,0,0,0)'); g.addColorStop(0.28,'rgba(0,0,0,0.5)'); g.addColorStop(1,'rgba(0,0,0,0)'); if (f>0){ c.fillStyle=g; c.fillRect(0,yb,WW,26); } }
      [[0,1],[WW,-1]].forEach(function(e){ var g=c.createLinearGradient(e[0],0,e[0]+e[1]*28,0); g.addColorStop(0,'rgba(0,0,0,0.55)'); g.addColorStop(1,'rgba(0,0,0,0)'); c.fillStyle=g; c.fillRect(e[1]>0?0:WW-28,0,28,WH); });
      return true; }
    window.TW8={bakeURL:function(){ return staticCv?staticCv.toDataURL('image/png'):null; }, camTo:function(x,y){ cam.free=x==null?null:{x:x,y:y}; }};   // 測試用
    if (!bakeTiles()){
"""
def patch(s):
    _a='get TOP(){return TOP;}, get BOT(){return BOT;}, FONT:FONT, HUM:HUM'
    assert s.count(_a)==1, s.count(_a)
    s=s.replace(_a,'get TOP(){return TOP;}, get BOT(){return BOT;}, get BTNS(){return buttons;}, FONT:FONT, HUM:HUM')
    def R(a,b,cnt=1):
        nonlocal s
        assert s.count(a)==cnt,(a[:90],s.count(a)); s=s.replace(a,b)
    a="    var resPool=B.src.res, gPool=B.src.ground, ui=0;\n"
    R(a, TILES.lstrip('\n')+a)
    a="    c.fillStyle='rgba(220,220,160,0.25)'; for (var x=120;x<WW-100;x+=110) c.fillRect(x,fy(0)-4,60,3);\n"
    R(a, a+"    }\n")
    return s
